# Github action runner in docker

Inspired by this [article](https://testdriven.io/blog/github-actions-docker/)

## Requirements

Need 2 env variables:

- Organization name
- PAT for registering runner(should have organization admin rights)

## Notes

- Latest runner [version](https://github.com/actions/runner/releases)
- To specify docker group on your host provide `DOCKER_GROUP` env variable