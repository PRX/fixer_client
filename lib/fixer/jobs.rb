# -*- encoding: utf-8 -*-

module Fixer
  class Jobs < API
    include Configuration

    def tasks(params={}, &block)
      @jobs ||= ApiFactory.api('Fixer::Tasks', self, params, &block)
    end
  end
end
