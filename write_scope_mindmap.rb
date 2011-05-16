$LOAD_PATH <<File.expand_path('../lib',__FILE__)
require 'mindmap'

scope = 'Scope:82559'
scope_name = 'Enterprise'

mm = MindMap.new('http://www7.v1host.com/V1Production/', 'joellen', 'carter')

mm.write_scope_data(scope, scope_name)

