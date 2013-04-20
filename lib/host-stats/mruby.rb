class Class
  
  unless respond_to?(:private)
    def private
      # mruby does not supports adding private method
    end
  end
  
  unless respond_to?(:protected)
    def protected
      # mruby does not supports adding protected method
    end
  end

  
end
