if [[ -z $HONEYCOMB_API_KEY ]]
then
  echo "please define HONEYCOMB_API_KEY"
  exit 1
fi

export OTEL_EXPORTER_OTLP_HEADERS="X-Honeycomb-Team=$HONEYCOMB_API_KEY"
export OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io"
export OTEL_SERVICE_NAME="script"

this_program="$0"
echo "This program: $this_program"
root_span=$(otel-cli span --tp-print --name "$this_program"  | grep TRACEPARENT)
echo $root_span
export $root_span #this will put future commands in here



function link_to_trace () {
  traceparent_var=$1
  trace_id=$(echo $traceparent_var | cut -d '-' -f 2)
  echo "Trace ID is $trace_id"
  echo "https://ui.honeycomb.io/modernity/environments/mango/datasets/script/trace?trace_id=$trace_id"
}

link_to_trace $root_span

function in_span {
  local command=$*
  echo "Let's run a span around: <$command>"
  otel-cli --name "$command" --attrs "message=hello" exec "$command"
}

#
# Main
#

# aws eks list-nodegroups --cluster-name demo
# in_span aws eks delete-nodegroup --no-cli-pager --nodegroup-name main --cluster-name demo

# aws eks list-clusters
# in_span aws eks delete-cluster --no-cli-pager --name demo

## ok, deleting the cluster was too easy.
## The console https://us-east-2.console.aws.amazon.com/resource-groups/tag-editor/find-resources?region=us-east-2#query=regions:!%28us-west-2%29,resourceTypes:!%28%27AWS::AllSupported%27%29,tagFilters:!%28%29,type:TAG_EDITOR_1_0
## reveals at least 41 other resources.
## I think our end goal may be to delete the VPC

#!/bin/bash

# Specify the VPC ID of the VPC to be deleted
VPC_ID="vpc-04a5a1b3c1aa0960a"

# Delete all associated resources


# Delete all instances
for INSTANCE_ID in $(aws ec2 describe-instances --filters "Name=vpc-id,Values=$VPC_ID" --query 'Reservations[*].Instances[*].InstanceId' --output text); do
    echo "Terminating instance $INSTANCE_ID"
    in_span aws ec2 terminate-instances --instance-ids $INSTANCE_ID
    # Wait for the instance to terminate
    in_span aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID
done

# Detach and delete all network interfaces
for NETWORK_INTERFACE_ID in $(aws ec2 describe-network-interfaces --filters "Name=vpc-id,Values=$VPC_ID" --query 'NetworkInterfaces[*].NetworkInterfaceId' --output text); do
    echo "Detaching network interface $NETWORK_INTERFACE_ID"
    in_span aws ec2 detach-network-interface --attachment-id $(aws ec2 describe-network-interfaces --network-interface-ids $NETWORK_INTERFACE_ID --query 'NetworkInterfaces[*].Attachment.AttachmentId' --output text)
    echo "Deleting network interface $NETWORK_INTERFACE_ID"
    in_span aws ec2 delete-network-interface --network-interface-id $NETWORK_INTERFACE_ID
done

# Delete all security group rules
for SECURITY_GROUP_ID in $(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query 'SecurityGroups[*].GroupId' --output text); do
    echo "Deleting security group rules for $SECURITY_GROUP_ID"
    for PERMISSION_ID in $(aws ec2 describe-security-group-rules --filters "Name=group-id,Values=$SECURITY_GROUP_ID" --query 'SecurityGroupRules[*].{ID:Id}' --output text); do
        in_span aws ec2 revoke-security-group-ingress --group-id $SECURITY_GROUP_ID --egress --protocol all --source-security-group-rule-id $PERMISSION_ID
        in_span aws ec2 revoke-security-group-ingress --group-id $SECURITY_GROUP_ID --ingress --protocol all --source-security-group-rule-id $PERMISSION_ID
    done
done

# Delete all network ACL rules
for NETWORK_ACL_ID in $(aws ec2 describe-network-acls --filters "Name=vpc-id,Values=$VPC_ID" --query 'NetworkAcls[*].NetworkAclId' --output text); do
    echo "Deleting network ACL rules for $NETWORK_ACL_ID"
    for ENTRY_ID in $(aws ec2 describe-network-acls --network-acl-ids $NETWORK_ACL_ID --query 'NetworkAcls[*].Entries[*].{ID:EntryId}' --output text); do
        in_span aws ec2 delete-network-acl-entry --network-acl-id $NETWORK_ACL_ID --rule-number $(aws ec2 describe-network-acls --network-acl-ids $NETWORK_ACL_ID --query "NetworkAcls[*].Entries[?EntryId=='$ENTRY_ID'].{Number:RuleNumber}" --output text)
    done
done

# Delete all subnets
for SUBNET_ID in $(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[*].SubnetId' --output text); do
    echo "Deleting subnet $SUBNET_ID"
    in_span aws ec2 delete-subnet --subnet-id $SUBNET_ID
done

# Delete all internet gateways
for IGW_ID in $(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query 'InternetGateways[*].InternetGatewayId' --output text); do
    echo "Deleting internet gateway $IGW_ID"
    in_span aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
    in_span aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID
done

# Delete all route tables
for ROUTE_TABLE_ID in $(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --query 'RouteTables[*].RouteTableId' --output text); do
    echo "Deleting route table $ROUTE_TABLE_ID"
    in_span aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID
done

# Delete all security groups
for SECURITY_GROUP_ID in $(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --query 'SecurityGroups[*].GroupId' --output text); do
    echo "Deleting security group $SECURITY_GROUP_ID"
    in_span aws ec2 delete-security-group --group-id $SECURITY_GROUP_ID
done

# Delete the VPC
echo "Deleting VPC $VPC_ID"
in_span aws ec2 delete-vpc --vpc-id $VPC_ID

echo "VPC deletion completed."

