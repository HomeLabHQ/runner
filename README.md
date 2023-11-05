# Github action runner in docker

Inspired by this [article](https://testdriven.io/blog/github-actions-docker/)

## Requirements

Need 2 env variables:

- Organization name
- PAT for registering runner(should have organization admin rights)
- `DOCKER_GROUP` to use dockerindocker

## Notes

- List of packages that present in github ubuntu-latest can be found here [packages](https://raw.githubusercontent.com/actions/runner-images/main/images/linux/toolsets/toolset-2204.json)
- Latest runner [version](https://github.com/actions/runner/releases)
- To specify docker group on your host provide `DOCKER_GROUP` env variable
