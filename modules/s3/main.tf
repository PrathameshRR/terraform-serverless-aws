resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this,
  ]

  bucket = aws_s3_bucket.this.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_object" "html" {
  bucket       = aws_s3_bucket.this.id
  key          = "index.html"
  source       = "${path.module}/../../frontend/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/../../frontend/index.html")

  depends_on = [aws_s3_bucket_website_configuration.this]
}

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.this.id
  key          = "styles.css"
  source       = "${path.module}/../../frontend/styles.css"
  content_type = "text/css"
  etag         = filemd5("${path.module}/../../frontend/styles.css")

  depends_on = [aws_s3_bucket_website_configuration.this]
}

resource "aws_s3_object" "js" {
  bucket       = aws_s3_bucket.this.id
  key          = "script.js"
  source       = "${path.module}/../../frontend/script.js"
  content_type = "application/javascript"
  etag         = filemd5("${path.module}/../../frontend/script.js")

  depends_on = [aws_s3_bucket_website_configuration.this]
}
