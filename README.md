stages:
  - build

variables:
  DOCKERLABEL_KEYONE: "VALUEONE"
  DOCKERLABEL_KEYTWO: "VALUETWO"

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
      echo "Using labels: $LABELS"
      docker build $LABELS -t "$CI_REGISTRY_IMAGE:latest" .
    - docker push "$CI_REGISTRY_IMAGE:latest"