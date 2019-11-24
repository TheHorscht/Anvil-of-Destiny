if not DOFILE_CACHE then
  DOFILE_CACHE = {}
  function dofile_cached(path)
      if DOFILE_CACHE[path] then return end
      dofile(path)
      DOFILE_CACHE[path] = true
  end
end
