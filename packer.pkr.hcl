source "docker" "python" {
  image       = var.python_image
  commit      = true
  run_command = ["-d", "-i", "-t", "--entrypoint=/bin/bash", "{{ .Image }}"]
  changes     = [
    "ENTRYPOINT . /opt/venv/bin/activate && exec python main.py"
  ]
}

build {
  sources = ["source.docker.python"]

  provisioner "file" {
    source      = "src/requirements.txt"
    destination = "requirements.txt"
  }

  provisioner "file" {
    source      = "src/main.py"
    destination = "main.py"
  }

  provisioner "shell" {
    inline = ["python3 -m venv /opt/venv && . /opt/venv/bin/activate && pip install -r requirements.txt --upgrade pip"]
  }

  post-processors {

    post-processor "docker-tag" {
      repository = var.ecr_url
      tag        = [var.image_tag]
    }

    post-processor "docker-push" {
      ecr_login    = true
      login_server = "https://${var.ecr_url}"
    }
  }
}
