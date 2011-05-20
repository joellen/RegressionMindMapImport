$LOAD_PATH <<File.expand_path('../lib',__FILE__)
require 'write_mindmap'

oid = 'RegressionPlan:210635'

mm = MindMap.new('http://www7.v1host.com/V1Production/', 'joellen', 'carter')

mm.write_mindmap(oid)

