#!/bin/bash
# bash <(curl -s https://raw.githubusercontent.com/RomanTsibii/nodes/main/ssh.sh)

mkdir -p ~/.ssh
# my
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYdj6sGiUsX9MG77gLlOfmv9ea1HG2kIkJpdFxprRSMUoVmWEBa4PaTYqHzRgb7Hf1XegJo5qeZ6zrR/jeSDxmqI4oCLhLQz3N6+oTpGD2KjlJYn2artpiIUQlQA4NBWD+jfqTBlbe2/s9xFzEynrr364QSDelyYdfHMtjaHtyK6oixat2lT/mJW1rlvorzp866IfbwV9KgvZqfHcHhYGwX78X8iYml07LxkujVdeRA+58yVOiPArsgRsgzwG5qZ9DE+T+bE2GzCivHcNsuh2laHcSAxHaLKV45VOUBcj8zjetpjRu9fSSImsjGtP2/PKB37H0QQZwOp7ZJ/TuimqJ6/NzEi6R08ZVnPCiJ/G+Sq9+E4f5TqFA6MZO1YtfF2qV46lFpQu843aBogzUnujWnSQcqeCQpLLIcea7DHHgEw3iXuJ7YtsT4zj1jMcuO8af4yP3RkjIRTAboET+dad+gcw0rSuqZEi9gLvRqj1IujMsFZyjzWU6MpMuOg9laJU= noteboot_dell@localhost >> ~/.ssh/authorized_keys
# artur
echo ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINP4kbYQIDfL8YbI889mV/W+Dq+kYpzu8OA63pVWpUB3 ubuntu@DESKTOP-GII69AB >> ~/.ssh/authorized_keys
