# -*- encoding: utf-8 -*-

module Fixer
  class Client < API
    def jobs(params={}, &block)
      @jobs ||= ApiFactory.api('Fixer::Jobs', self, params, &block)
    end
  end
end
