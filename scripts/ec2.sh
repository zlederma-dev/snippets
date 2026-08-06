#!/bin/bash
# Usage:
#   ./scripts/ec2.sh start runner    # start GitHub Actions runner
#   ./scripts/ec2.sh start app       # start snippets-server
#   ./scripts/ec2.sh stop app        # stop snippets-server
#   ./scripts/ec2.sh start all       # start both
#   ./scripts/ec2.sh stop all        # stop both
set -e

REGION="us-east-1"

resolve() {
  local name=$1
  case $name in
    runner) ID="i-01d9f1cbc05920022"; LABEL="GitHub Actions runner" ;;
    app)    ID="i-0217834bcf342564b";  LABEL="snippets-server" ;;
  esac
}

usage() {
  echo "Usage: $0 {start|stop} {runner|app|all}"
  exit 1
}

start_instance() {
  resolve "$1"

  echo "Starting ${LABEL} (${ID})..."
  aws ec2 start-instances --instance-ids "$ID" --region "$REGION" > /dev/null

  echo "Waiting for ${LABEL} to be running..."
  aws ec2 wait instance-running --instance-ids "$ID" --region "$REGION"

  local ip
  ip=$(aws ec2 describe-instances \
    --instance-ids "$ID" \
    --region "$REGION" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

  echo "${LABEL} is up at ${ip}"
}

stop_instance() {
  resolve "$1"

  echo "Stopping ${LABEL} (${ID})..."
  aws ec2 stop-instances --instance-ids "$ID" --region "$REGION" > /dev/null

  echo "Waiting for ${LABEL} to stop..."
  aws ec2 wait instance-stopped --instance-ids "$ID" --region "$REGION"

  echo "${LABEL} is stopped"
}

[[ $# -ne 2 ]] && usage

ACTION=$1
TARGET=$2

case $ACTION in
  start|stop) ;;
  *) usage ;;
esac

case $TARGET in
  runner|app)
    "${ACTION}_instance" "$TARGET"
    ;;
  all)
    for name in runner app; do
      "${ACTION}_instance" "$name"
    done
    ;;
  *) usage ;;
esac
