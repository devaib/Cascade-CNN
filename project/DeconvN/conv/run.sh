qlua run.lua -p cuda -e true -r 1e-2 -w 1e-5 -z 60 
qlua run.lua -p cuda -e true -r 1e-3 -w 1e-5 -z 30 -l '/home/jblan016/Desktop/project/DeconvN/conv/results/modelV.net'
qlua run.lua -p cuda -e true -r 1e-4 -w 1e-6 -z 15 -l '/home/jblan016/Desktop/project/DeconvN/conv/results/modelV.net'
