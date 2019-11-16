if attach_frame == nil then attach_frame = GameGetFrameNum(); end
if attach_frame % 60 == 0 then GamePrint("tick"); end

if attach_frame >= 180 then
    local entity = GetUpdatedEntityID();
    EntityRemoveComponent( entity, EntityGetFirstComponent( entity, "LuaComponent", "counter_example_script" ) );
end
attach_frame = attach_frame + 1;