function HitSquash(obj, hitForce, timeMult, down, up)
  timeMult = timeMult or 1
  down = down or 1
  up = up or 1

  local squishTime = 0.2 * timeMult * down
  local unsquishTime = 0.05 * timeMult * up
  local superSquishTime = 0.05 * timeMult * up
  local finalSquish = 0.08 * timeMult * up
  local initialSq = obj.squashAmount
  local superSquishAmount = 0.1 * (1 / hitForce)

  overTime(squishTime, function(p, c, t)
    obj.squashAmount = initialSq + hitForce * Easing.OutCirc(p, 0, 1, 1)
  end)

  overTime(unsquishTime, function(p, c, t)
    obj.squashAmount = initialSq + hitForce - hitForce * 1 * Easing.OutCirc(p, 0, 1, 1)
  end)

  overTime(superSquishTime, function(p, c, t)
    obj.squashAmount = initialSq - hitForce * superSquishAmount * Easing.OutCirc(p, 0, 1, 1)
  end)

  overTime(finalSquish, function(p, c, t)
    obj.squashAmount = initialSq + - hitForce * superSquishAmount + hitForce * superSquishAmount * Easing.OutCirc(p, 0, 1, 1)
  end)

  obj.squashAmount = initialSq
end