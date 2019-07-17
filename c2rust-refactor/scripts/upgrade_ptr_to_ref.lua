require "utils"

Visitor = {}

function Visitor.new(node_id)
   self = {}
   self.node_ids = node_ids

   setmetatable(self, Visitor)
   Visitor.__index = Visitor

   return self
end

function Visitor:visit_arg(arg)
    arg_ty = arg:get_ty()

    if self.node_ids[arg:get_id()] and arg_ty:get_kind() == "Ptr" then
        arg_ty:to_rptr(nil, arg_ty:get_mut_ty())
        arg:set_ty(arg_ty)
    end
end

refactor:transform(
    function(transform_ctx)
        node_ids = Set.new{12, 21}
        return transform_ctx:visit_crate_new(Visitor.new(node_ids))
    end
)

print("Finished upgrade_ptr_to_ref.lua")
