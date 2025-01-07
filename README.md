
# GitLab CI Templates

This repository provides reusable GitLab CI templates for automating Docker image builds, pushing them to Artifactory, and updating manifest files with the correct image and tag. These templates make it easier to manage Docker image updates and streamline your CI/CD pipeline.

## Templates Overview

### 1. `update-manifests.yml`
This template is used to update **`values`** and **`manifest`** files with the correct image repository and tag. It modifies the following fields:
- **`repository:`**: The Docker repository (composed of `ARTIFACTORY_DOCKER_REPOSITORY` + `ARTIFACTORY_SUFFIX`).
- **`tag:`**: The Docker image tag (usually based on the GitLab commit hash `CI_COMMIT_SHORT_SHA`).
- **`image:`**: The full Docker image name with the tag (including quotes).

This template works by cloning the repository containing the `values` and `manifest` files, checking for missing files, and updating the necessary image repository and tag fields. It then commits these changes back to the repository.

### 2. `build_and_push.yml`
This template is used for **building Docker images** and **pushing them to Artifactory**. It handles the process of logging into Artifactory, building the image, tagging it with the commit hash, and pushing it to the Artifactory repository. 

This template supports both **automatic pushes** and **manual pushes** to Artifactory, depending on the job configuration.

## How to Use These Templates

### 1. **Including the Templates**

To include both templates in your GitLab pipeline, add the following to your `.gitlab-ci.yml` file:

```yaml
include:
  - project: 'your-org/ci-templates'
    file: '/update-manifests.yml'
  - project: 'your-org/ci-templates'
    file: '/build_and_push.yml'

This will make both the update-manifests and build_and_push templates available for use within your pipeline configuration.

2. Extending the Templates in Pipeline Jobs

Once the templates are included, you can extend them in your pipeline jobs.

Use Case 1: Update Manifests for Development

For example, you can extend the update-manifests template to automatically update the values and manifest files for the development environment when a commit is pushed to the develop branch.

update-manifests-development:
  extends: .update-manifests
  variables:
    ENVIRONMENT: "development"
    ZONE: "intranet"
  only:
    - develop
  when: always

Use Case 2: Build and Push Docker Image to Artifactory (Manual Trigger)

Similarly, you can extend the build_and_push template to build and push Docker images to Artifactory. For example, you can manually trigger the push to the staging repository when you're ready to deploy.

manual-push-staging:
  extends: .build_and_push_template
  variables:
    ARTIFACTORY_DOCKER_REPOSITORY: "staging"
    ARTIFACTORY_SUFFIX: ".artifactory.com"
    IMAGE_NAME_AND_TAG: "$CI_PROJECT_NAME:$CI_COMMIT_SHORT_SHA"
  when: manual
  only:
    - develop

Use Case 3: Update Manifests (Development Environment)

This job automatically updates the values and manifest files for the development environment with the latest image and tag.

update-manifests-development:
  extends: .update-manifests  # Use the update-manifests template
  variables:
    ENVIRONMENT: "development"  # Set the environment to "development"
    ZONE: "intranet"  # Set the zone to "intranet"
  only:
    - develop  # Trigger only for the develop branch
  when: always  # Automatically triggered on develop branch


---

Summary of Variables

Here is a summary of the key variables used in both templates:


---

Conclusion

This README.md serves as a guide for understanding and using the update-manifests.yml and build_and_push.yml templates in your GitLab CI pipeline. By including and extending these templates, you can easily automate the process of building Docker images, pushing them to Artifactory, and updating configuration files like values and manifest.


---

Let me know if you'd like any further modifications or additional information in the README.md!

You can now copy and paste this **`README.md`** file directly. Let me know if you need further adjustments!

