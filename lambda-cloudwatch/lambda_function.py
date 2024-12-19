import boto3 #importing boto3 SDK

def modifyVolume(vol_arn):
# splitting the volume name
  arn_parts = vol_arn.split(':')
# volume id is taken from the splitted string. volume id is in the last. So it is traversed from back
  vol_id = arn_parts[-1].split('/')[-1]
  return vol_id

def lambda_handler(event, context):
# volume name is extracted from event.resources[0]
  vol_arn = event['resources'][0]
# modify volume function is called and volume name is passed as an argument
  vol_id = modifyVolume(vol_arn)
# EC2 client is called using boto3 and is stored in a variable
  ec2_client = boto3.client('ec2')
# This variable is used to call the modify_volume method
  response = ec2_client.modify_volume(
      VolumeId = vol_id,
      VolumeType = 'gp3',
  )
