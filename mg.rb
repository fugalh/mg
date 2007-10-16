#!/usr/bin/ruby
## Configuration
# height in cm
height = 193
ymin = 100
ymax = 125
S = 0.9 # smoothing factor for exponentially smoothed moving average
## End Configuration

require 'date'
h2 = (height*1e-2)**2

plot = <<EOF
set xdata time
set timefmt '%Y-%m-%d'

# coupling the y axes requires knowing the yrange, for now
ymin=#{ymin}
ymax=#{ymax}
h2=#{h2}
set ytics nomirror
set xtics nomirror
set y2tics
set yrange [ymin:ymax]
set y2range [ymin/h2:ymax/h2]

set ylabel 'kg'
set y2label 'BMI and percent body fat'
set title 'Weight and Body Fat Percentage'

set terminal svg 

plot '-' u 1:2 t 'Weight' w dots, \
     '-' u 1:3 t 'Weight Trend' w l, \
     '-' u 1:4 ax x1y2 t '%BF' w dots, \
     '-' u 1:5 ax x1y2 t '%BF Trend' w l
EOF

data = []
weights = []
fats = []
ARGF.each_line do |l|
  l.strip!
  next if l =~ /^\s*(#|$)/

  d,w,f = l.split
  d = Date.parse(d)
  w = w.to_f

  weights << [d, w]
  t = den = 0
  weights.each do |d2,w2|
    s = S**(d-d2-1)
    t += s * w2
    den += s
  end
  t /= den
  datum = [d,w,t]

  if f
    f = f.to_f
    fats << [d, f]
    t = den = 0
    fats.each do |d2,w2|
      s = S**(d-d2-1)
      t += s * w2
      den += s
    end
    t /= den
    datum += [f,t]
  end

  data << datum
end

IO.popen('gnuplot','w') do |f|
  f.puts plot
  4.times { f.puts data.map {|d| d.join(" ")}.join("\n"); f.puts 'e' }
end
