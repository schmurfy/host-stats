
# What ?

This library goal is to provide the tools to query host usage stats using mainly libsigar for now.


This gem is actually useable as a standard ruby gem but also as a mruby gem


# Using with Mruby

Obviously you firt need a local copy of the mruby git tree, then you can add
the gem in your build_config.rb, if you have a local copy this would be:

(you need my mruby-cfunc fork untils changes got merged)
```ruby
conf.gem :github => 'schmurfy/mruby-cfunc', :branch => 'ruby_ffi'
conf.gem :github => 'schmurfy/host-stats', :branch => 'master'
```

and you are done, just build mruby with "rake"


