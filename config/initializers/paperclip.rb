Paperclip.interpolates(:s3_domain_url) { |attachment, style|
  "#{attachment.s3_protocol}://s3-eu-central-1.amazonaws.com/#{attachment.bucket_name}/#{attachment.path(style).gsub(%r{^/}, '')}"
}