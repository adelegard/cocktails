module RoundingHelper

  # rounds numbers over one-thousand down to their "k" (thousand) equivalent
  def round_k(num)

    # uncomment the line below to test this out
    #num = [*1..9999].sample
    if num >= 1_000 && num < 10_000
      num_f = 1
    elsif num >= 10_000
      num_f = 0
    end
    num_f != nil ? ("%g" % (("%." + num_f.to_s + "f") % (num/1_000.0)) + "k") : num
  end

end