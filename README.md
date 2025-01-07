Here's an updated version of your pipeline that explicitly shows the labels if they are set and provides a clear message if no labels are defined. This ensures better logging and transparency during the build process.

Updated .gitlab-ci.yml with Detailed Logging:

stages:
  - build

variables:
  # Example variables (uncomment to test with labels)
  # DOCKERLABEL_KEYONE: "VALUEONE"
  # DOCKERLABEL_KEYTWO: "VALUETWO"

build_stage:
  stage: build
  image: docker:stable
  services:
    - docker:dind
  script:
    - echo "Building Docker image..."
    - echo "Parsing DOCKERLABEL_ variables..."
    - |
      LABELS=""
      for VAR in $(printenv | grep -E '^DOCKERLABEL_' | awk -F= '{print $1}'); do
        KEY=${VAR#DOCKERLABEL_}
        VALUE=$(printenv "$VAR")
        LABELS="$LABELS --label $KEY=$VALUE"
      done
      if [ -z "$LABELS" ]; then
        echo "No labels provided. Proceeding without labels."
        docker build -t "$CI_REGISTRY_IMAGE:latest" .
      else
        echo "The following labels will be applied:"
        for VAR in $(printenv | grep -E '^DOCKERLABEL_' | awk -F= '{print $1}'); do
          KEY=${VAR#DOCKERLABEL_}
          VALUE=$(printenv "$VAR")
          echo "  $KEY=$VALUE"
        done
        docker build $LABELS -t "$CI_REGISTRY_IMAGE:latest" .
      fi
    - docker push "$CI_REGISTRY_IMAGE:latest"


---

What’s New:

1. Logging Labels if Set:

If labels are defined, the pipeline logs each label in a readable format:

The following labels will be applied:
  KEYONE=VALUEONE
  KEYTWO=VALUETWO



2. Graceful Fallback:

If no labels are provided, the pipeline logs a clear message:

No labels provided. Proceeding without labels.



3. Improved Debugging:

By explicitly showing the labels before running the docker build command, you ensure better visibility into the build process.





---

Example Scenarios:

With Labels:

variables:
  DOCKERLABEL_KEYONE: "VALUEONE"
  DOCKERLABEL_KEYTWO: "VALUETWO"

Pipeline Output:

Parsing DOCKERLABEL_ variables...
The following labels will be applied:
  KEYONE=VALUEONE
  KEYTWO=VALUETWO
Using labels: --label KEYONE=VALUEONE --label KEYTWO=VALUETWO

Without Labels:

# No DOCKERLABEL_ variables defined

Pipeline Output:

Parsing DOCKERLABEL_ variables...
No labels provided. Proceeding without labels.


---

This approach combines clean condition handling with verbose output for debugging and transparency. Let me know if you'd like further tweaks!

