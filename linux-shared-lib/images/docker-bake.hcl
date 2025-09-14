# https://docs.docker.com/build/bake/

group "default" {
  targets = ["clang", "gcc"]
}

variable "CALVER_VERSION" {
    default = "latest"
}

variable "CLANG_VERSION" {
    default = "17"
}

variable "GCC_VERSION" {
    default = "15"
}

target "clang" {
  context    = "./clang"
  dockerfile = "Dockerfile"
  args = {
    "VERSION" = CLANG_VERSION
  }
  tags       = ["andreynautilus/clang:${CLANG_VERSION}-${CALVER_VERSION}"]
}

target "gcc" {
  context    = "./gcc"
  dockerfile = "Dockerfile"
  args = {
    "VERSION" = GCC_VERSION
  }
  tags       = ["andreynautilus/gcc:${GCC_VERSION}-${CALVER_VERSION}"]
}
