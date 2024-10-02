# Github action runner in docker

Inspired by this [article](https://testdriven.io/blog/github-actions-docker/)

## Requirements

Need 2 env variables:

- Organization name
- PAT for registering runner(should have organization admin rights)
- `DOCKER_GROUP` to use dockerindocker(dind)

## Notes

- I'm hosting this on 4CPU core minipc so compose.yml have 4 replicas, feel free to modify it for your environment
- List of packages that present in github ubuntu-latest can be found here [packages](https://github.com/actions/runner-images/blob/main/images/ubuntu/toolsets/toolset-2404.json)
- Latest runner [version](https://github.com/actions/runner/releases)
- To specify docker group on your host provide `DOCKER_GROUP` env variable
