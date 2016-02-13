require 'active_support/security_utils'

module ActiveElasticJob
  class MessageVerifier #:nodoc:

    # Raised when digest generated by
    # <tt>ActiveJob::QueueAdapters::ActiveElasticJobAdapter</tt> could not
    # be verified.
    class InvalidDigest < StandardError
    end

    def initialize(secret)
      @secret = secret
    end

    def verify(message, digest)
      if message.nil? || message.blank? || digest.nil? || digest.blank?
        return false
      end

      return ActiveSupport::SecurityUtils.secure_compare(
        digest, generate_digest(message))
    end

    def verify!(message, digest)
      raise InvalidDigest unless verify(message, digest)
    end

    def generate_digest(message)
      require 'openssl' unless defined?(OpenSSL)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, @secret, message)
    end
  end
end
