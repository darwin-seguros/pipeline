# Darwin Seguros - Pipeline

<!---
[![CircleCI Build Status](https://circleci.com/gh/darwin-seguros/pipeline.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/darwin-seguros/pipeline) [![CircleCI Orb Version](https://badges.circleci.com/orbs/darwin-seguros/pipeline.svg)](https://circleci.com/developer/orbs/orb/darwin-seguros/pipeline) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/darwin-seguros/pipeline/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

--->

Pipeline's CircleCI Orb.

This repository is a ORB to CI and CD for Darwin Seguros.

---
## Resources

### How to Contribute

We welcome [issues](https://github.com/darwin-seguros/pipeline/issues) to and [pull requests](https://github.com/darwin-seguros/pipeline/pulls) against this repository!

### How to Publish An Update
1. Merge pull requests with desired changes to the main branch.
    - For the best experience, squash-and-merge and use [Conventional Commit Messages](https://conventionalcommits.org/).
2. Find the current version of the orb.
    - You can run `circleci orb info darwin-seguros/pipeline | grep "Latest"` to see the current version.
3. Create a [new Release](https://github.com/darwin-seguros/pipeline/releases/new) on GitHub.
    - Click "Choose a tag" and _create_ a new [semantically versioned](http://semver.org/) tag. (ex: v1.0.0)
      - We will have an opportunity to change this before we publish if needed after the next step.
4.  Click _"+ Auto-generate release notes"_.
    - This will create a summary of all of the merged pull requests since the previous release.
    - If you have used _[Conventional Commit Messages](https://conventionalcommits.org/)_ it will be easy to determine what types of changes were made, allowing you to ensure the correct version tag is being published.
5. Now ensure the version tag selected is semantically accurate based on the changes included.
6. Click _"Publish Release"_.
    - This will push a new tag and trigger your publishing pipeline on CircleCI.
