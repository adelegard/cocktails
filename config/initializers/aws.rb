if Rails.env == "production" 
   S3_CREDENTIALS = { :access_key_id => ENV['AKIAJNDWPCPJTY4UA7XA'], :secret_access_key => ENV['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'], :bucket => "adelegard_cocktails"}
 else 
   S3_CREDENTIALS = Rails.root.join("config/s3.yml")
end