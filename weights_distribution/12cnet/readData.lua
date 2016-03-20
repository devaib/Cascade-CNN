require 'nn'
require 'csvigo'

mdl = torch.load('./model.net')

_convWeights = mdl.modules[1].weight
_convBias = mdl.modules[1].bias

_fcWeights1 = mdl.modules[4].weight
_fcBias1 = mdl.modules[4].bias

_fcWeights2 = mdl.modules[7].weight
_fcBias2= mdl.modules[7].bias

convWeights = {}
convBias = {}
fcWeights1 = {}
fcBias1 = {}
fcWeights2 = {}
fcBias2 = {}

for i = 1, _convWeights:size(1) do
    convWeights[i] = {}
    for j = 1, _convWeights:size(2) do
        convWeights[i][j] = _convWeights[i][j]
    end
end

convBias[1] = {}
for i = 1, _convBias:size(1) do
    convBias[1][i] = _convBias[i]
end

for i = 1, _fcWeights1:size(1) do
    fcWeights1[i] = {}
    for j = 1, _fcWeights1:size(2) do
        fcWeights1[i][j] = _fcWeights1[i][j]
    end
end

fcBias1[1] = {}
for i = 1, _fcBias1:size(1) do
    fcBias1[1][i] = _fcBias1[i]
end

for i = 1, _fcWeights2:size(1) do
    fcWeights2[i] = {}
    for j = 1, _fcWeights2:size(2) do
        fcWeights2[i][j] = _fcWeights2[i][j]
    end
end

fcBias2[1] = {}
for i = 1, _fcBias2:size(1) do
    fcBias2[1][i] = _fcBias2[i]
end

csvigo.save({path = './convWeights.csv', data = convWeights, mode = 'raw'})
csvigo.save({path = './convBias.csv', data = convBias, mode = 'raw'})
csvigo.save({path = './fcWeights1.csv', data = fcWeights1, mode = 'raw'})
csvigo.save({path = './fcBias1.csv', data = fcBias1, mode = 'raw'})
csvigo.save({path = './fcWeights2.csv', data = fcWeights2, mode = 'raw'})
csvigo.save({path = './fcBias2.csv', data = fcBias2, mode = 'raw'})

