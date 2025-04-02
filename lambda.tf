resource "null_resource" "go_lambda_build" {
  triggers = {
    source_code = filemd5("${path.module}/src/hello-world/main.go")
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${path.module}/src/hello-world
      if [ ! -f go.mod ]; then
        go mod init hello-world
      fi
      export GOPROXY=direct
      go mod tidy
      GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap main.go
    EOT
  }
}

module "hello-world-lambda" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "hello-world"
  description   = "Hello world Lambda created in Go"
  handler       = "bootstrap"
  runtime       = "provided.al2023"

  source_path = "${path.module}/src/hello-world"
  depends_on = [null_resource.go_lambda_build]
  publish = true
  
}