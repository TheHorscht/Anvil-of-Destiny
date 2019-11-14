function get_probability_value_for_inserting(spawn_table, percent)
  local total_prob = 0
  if spawn_table.total_prob ~= 0 then
    total_prob = spawn_table.total_prob
  else
    -- sum up probabilities
    for i,v in ipairs(spawn_table) do
      if v.prob ~= nil then
        total_prob = total_prob + v.prob
      end
    end
  end

  if percent >= 1 then
    percent = 0.99999
  end

  return (total_prob / (1 - percent)) - total_prob
end
