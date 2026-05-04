
/* Add the 8 objects */

BUtils.loadLiveObjects;

(

var bus=0;

~awarePrepend = "/Users/bjarni/Works/SND/aware";
~items = Array.new(8);
~release = 1.2;
~savedObjects = List.new;
~awareObjPrepend = "/Users/bjarni/Works/SND/aware/_init/";
~awarePrepend = "/Users/bjarni/Works/SND/aware/";
~globalDur = 500;

~items.add(BNetworkItem.new(BLSynth5, [\outBus, bus, \duration, ~globalDur], "Test"));

~items.add(BNetworkItem.new(BLGest8, [\outBus, bus, \sound, "/Users/bjarni/Works/PIECES/Interactions/Other/clicks/micralis-05.wav", \duration, ~globalDur], "Carbono"));
~items.add(BNetworkItem.new(BLGest8, [\outBus, bus, \sound,  ~awarePrepend ++ "/textures/atd.wav", \duration, ~globalDur], "HiTxtCutt"));
~items.add(BNetworkItem.new(BLGest4, [\outBus, bus, \sound, ~awarePrepend ++ "/sequences/asd.wav", \duration, ~globalDur], "Cutti"));
~items.add(BNetworkItem.new(BLSynth3, [\outBus, bus, \duration, ~globalDur], "Gritera"));
~items.add(BNetworkItem.new(BLPat6, [\outBus, bus, \frequencies, [ 8000, 8300, 8600, 8900 ], \waveform, 2, \duration, ~globalDur], "Opal"));
~items.add(BNetworkItem.new(BLPat1, [\outBus, bus, \sounds, ~awarePrepend ++ "/grains/h/mono/*", \duration, ~globalDur], "Teros"));
~items.add(BNetworkItem.new(BLSynth7, [\outBus, bus, \curveType, 4, \duration, ~globalDur], "Pulcao"));
~items.add(BNetworkItem.new(BLSynth2, [\outBus, bus, \duration, ~globalDur], "Montige"));

~livePresets12 = List.new;
~livePresets12.add(BControl.new(speed:0.8061, density:0.6194, frequency:0.9597, amplitude:0.9605, entropy:0.5336, color:0.8947, surface:0.2588, location:0.1251, position:0.6581, attack:0.001, release:0.001));
~livePresets12.add(BControl.new(speed:0.9127, density:0.4749, frequency:0.3607, amplitude:0.1447, entropy:0.4994, color:0.4474, surface:0.0453, location:0.6091, position:0.274, attack:0.001, release:0.001));
~livePresets12.add(BControl.new(speed:0.8553, density:0.1316, frequency:0.4759, amplitude:1, entropy:0.5991, color:0.6718, surface:0.6173, location:0.0254, position:0.7937, attack:0.001, release:0.001));
~livePresets12.add(BControl.new(speed:0.1316, density:0.0556, frequency:0.076, amplitude:0.7632, entropy:0.7723, color:0.2105, surface:0.1056, location:0.0466, position:0.0427, attack:0.001, release:0.001));
~livePresets12.add(BControl.new(speed:0.51, density:0.5105, frequency:0.5642, amplitude:0.9737, entropy:0.2889, color:0.5789, surface:0.8941, location:0.6442, position:0.6547, attack:0.001, release:0.001));
~livePresets12.add(BControl.new(speed:0.4206, density:0.198, frequency:0.0785, amplitude:0.8684, entropy:0.412, color:0.1447, surface:0.4648, location:0.8769, position:0.5658, attack:0.001, release:0.001));
~livePresets12.add(BControl.new(speed:0.5526, density:0.1974, frequency:0.2763, amplitude:0.9474, entropy:0.2535, color:0.2105, surface:0.0921, location:0.3788, position:0.5529, attack:0.001, release:0.001));
~livePresets12.add(BControl.new(speed:0.9225, density:0.3815, frequency:0.4726, amplitude:0.8289, entropy:0.0339, color:0.9837, surface:0.6499, location:0.4831, position:0.5996, attack:0.001, release:0.001));

~livePresets13 = List.new;
~livePresets13.add(BControl.new(speed:0.9349, density:0.4516, frequency:0.1849, amplitude:0.5132, entropy:0.3109, color:0.1718, surface:0.2208, location:0.1238, position:0.9811, attack:0.001, release:0.001));
~livePresets13.add(BControl.new(speed:0.4789, density:0.4395, frequency:0.4247, amplitude:0.75, entropy:0.3831, color:0.8616, surface:0.3755, location:0.5141, position:0.2645, attack:0.001, release:0.001));
~livePresets13.add(BControl.new(speed:0.2775, density:0.1849, frequency:0.1688, amplitude:0.9342, entropy:0.7399, color:0.0658, surface:0.5633, location:0.3754, position:0.7071, attack:0.001, release:0.001));
~livePresets13.add(BControl.new(speed:0.0395, density:0.837, frequency:0.3289, amplitude:0.9342, entropy:0.1842, color:0, surface:0.6316, location:0.3158, position:0.3553, attack:0.001, release:0.001));
~livePresets13.add(BControl.new(speed:0.4836, density:0.5057, frequency:0.5504, amplitude:0.9342, entropy:0.6176, color:0.0658, surface:0.2143, location:0.9576, position:0.7505, attack:0.001, release:0.001));
~livePresets13.add(BControl.new(speed:0.0101, density:0.0534, frequency:0.2448, amplitude:0.9342, entropy:0.2872, color:0.0526, surface:0.0132, location:0.4321, position:0.0122, attack:0.001, release:0.001));
~livePresets13.add(BControl.new(speed:0.9634, density:0.6528, frequency:0.4918, amplitude:0.9342, entropy:0.3044, color:0.0175, surface:0.0138, location:0.3058, position:0.1601, attack:0.001, release:0.001));
~livePresets13.add(BControl.new(speed:0.3681, density:0.428, frequency:0.5085, amplitude:0.9342, entropy:0.01, color:0.44, surface:0.01, location:0.7668, position:0.6209, attack:0.001, release:0.001));

~livePresets36 = List.new;
~livePresets36.add(BControl.new(speed:0.3026, density:0.2763, frequency:0.5256, amplitude:0.9342, entropy:0.8971, color:0.7357, surface:0.0417, location:0.7571, position:0.8586, attack:0.001, release:0.001));
~livePresets36.add(BControl.new(speed:0.7368, density:0.693, frequency:0.4062, amplitude:0.6316, entropy:0.1931, color:0.7738, surface:0.6356, location:0.5278, position:0.1284, attack:0.001, release:0.001));
~livePresets36.add(BControl.new(speed:0.8315, density:0.0969, frequency:0.7835, amplitude:0.7237, entropy:0.255, color:0.1447, surface:0.8282, location:0.2628, position:0.8458, attack:0.001, release:0.001));
~livePresets36.add(BControl.new(speed:0.3421, density:0.7632, frequency:0.0395, amplitude:0.5658, entropy:0.9185, color:0.3677, surface:0.318, location:0.4013, position:0.6747, attack:0.001, release:0.001));
~livePresets36.add(BControl.new(speed:0.2357, density:0.4497, frequency:0.7628, amplitude:0.9079, entropy:0.9479, color:0.9272, surface:0.8684, location:0.2966, position:0.3179, attack:0.001, release:0.001));
~livePresets36.add(BControl.new(speed:0.668, density:0.7368, frequency:0.9737, amplitude:0.7368, entropy:1, color:0.5263, surface:0.1584, location:0.2044, position:0.2889, attack:0.001, release:0.001));
~livePresets36.add(BControl.new(speed:0.8855, density:0.5224, frequency:0.6141, amplitude:0.7632, entropy:0.3825, color:0.956, surface:0.3879, location:0.632, position:0.1554, attack:0.001, release:0.001));
~livePresets36.add(BControl.new(speed:0.0789, density:0.6842, frequency:0.0921, amplitude:0.9342, entropy:0.3825, color:0.0921, surface:0.8684, location:0.632, position:0.1554, attack:0.001, release:0.001));

~livePresets38 = List.new;
~livePresets38.add(BControl.new(speed:0.4868, density:0.3994, frequency:0.5263, amplitude:0.9079, entropy:0.3414, color:0.1974, surface:0.3613, location:0.1143, position:0.1644, attack:0.001, release:0.001));
~livePresets38.add(BControl.new(speed:0.2592, density:0.4997, frequency:0.1432, amplitude:0.8026, entropy:0.6277, color:0.4603, surface:0.3688, location:0.8199, position:0, attack:0.001, release:0.001));
~livePresets38.add(BControl.new(speed:0.8783, density:0.1447, frequency:0.335, amplitude:0.8816, entropy:0.7595, color:0.2748, surface:0.9854, location:0.448, position:0.1934, attack:0.001, release:0.001));
~livePresets38.add(BControl.new(speed:0.606, density:0.1316, frequency:0.2763, amplitude:0.8553, entropy:0.1752, color:0.3816, surface:0.8947, location:0.3905, position:0.2368, attack:0.001, release:0.001));
~livePresets38.add(BControl.new(speed:0.9423, density:0.2663, frequency:0.8158, amplitude:0.8421, entropy:0.7964, color:0.1589, surface:0.6007, location:0.4079, position:0, attack:0.001, release:0.001));
~livePresets38.add(BControl.new(speed:0.1493, density:0.037, frequency:0.0365, amplitude:0.9605, entropy:0.3406, color:0.1711, surface:0.8951, location:0.4079, position:0, attack:0.001, release:0.001));
~livePresets38.add(BControl.new(speed:0.6095, density:0.5571, frequency:0.7144, amplitude:0.8553, entropy:0.3296, color:0.0395, surface:0.4903, location:0.0496, position:0.9208, attack:0.001, release:0.001));
~livePresets38.add(BControl.new(speed:0.8428, density:0.0117, frequency:0.8906, amplitude:0.8662, entropy:0.3263, color:0, surface:0.8913, location:0.4559, position:0.1617, attack:0.001, release:0.001));

~livePresets24 = List.new;
~livePresets24.add(BControl.new(speed:0.1463, density:0.1362, frequency:0.0918, amplitude:0.9737, entropy:0.2753, color:0.3816, surface:0.2378, location:0.4789, position:0.2538, attack:0.001, release:0.001));
~livePresets24.add(BControl.new(speed:0.4632, density:0.2518, frequency:0.9342, amplitude:0.7105, entropy:0.1842, color:0.0526, surface:0.4474, location:0.0681, position:0.4868, attack:0.001, release:0.001));
~livePresets24.add(BControl.new(speed:0.833, density:0.5817, frequency:0.6644, amplitude:0.7105, entropy:0.346, color:0.1176, surface:0.8947, location:0.1358, position:0.2747, attack:0.001, release:0.001));
~livePresets24.add(BControl.new(speed:0.0239, density:0.0603, frequency:0.4363, amplitude:0.8816, entropy:0.2261, color:0.1842, surface:0.7845, location:0.6053, position:0.887, attack:0.001, release:0.001));
~livePresets24.add(BControl.new(speed:0.4348, density:0.4377, frequency:0.3547, amplitude:0.8816, entropy:0.6878, color:0.0395, surface:0.1889, location:0.3156, position:0.1649, attack:0.001, release:0.001));
~livePresets24.add(BControl.new(speed:0.9206, density:0.2, frequency:0.9603, amplitude:0.8684, entropy:0.1895, color:0.3289, surface:0.4616, location:0.9403, position:0.0395, attack:0.001, release:0.001));
~livePresets24.add(BControl.new(speed:0.7406, density:0.2121, frequency:0.3004, amplitude:0.6974, entropy:0.0815, color:0.1316, surface:0.6184, location:0.0169, position:0.9474, attack:0.001, release:0.001));
~livePresets24.add(BControl.new(speed:0.1184, density:0.1793, frequency:0.1767, amplitude:0.8158, entropy:0.5646, color:0.0921, surface:0.6708, location:0.5417, position:0.3138, attack:0.001, release:0.001));
~livePresets24.add(BControl.new(speed:0.8665, density:0.3242, frequency:0.9475, amplitude:0.8158, entropy:0.7126, color:0.1053, surface:0.6099, location:0.6817, position:0.5884, attack:0.001, release:0.001));

~livePresets26 = List.new;
~livePresets26.add(BControl.new(speed:0.2642, density:0.9475, frequency:0.603, amplitude:0.8289, entropy:0.9716, color:0.2478, surface:0.1194, location:0.01, position:0.4007, attack:0.001, release:0.001));
~livePresets26.add(BControl.new(speed:0.4177, density:0.3045, frequency:0.2738, amplitude:0.9474, entropy:0.2976, color:0.3232, surface:0.5486, location:0.7045, position:0.113, attack:0.001, release:0.001));
~livePresets26.add(BControl.new(speed:0.8826, density:0.0577, frequency:0.6477, amplitude:0.8784, entropy:0.1784, color:0.1151, surface:0.7582, location:0.4224, position:0.3356, attack:0.001, release:0.001));
~livePresets26.add(BControl.new(speed:0.2997, density:0.9896, frequency:0.0592, amplitude:0.9474, entropy:0.9632, color:0.0526, surface:0.2143, location:0.4989, position:0.1617, attack:0.001, release:0.001));
~livePresets26.add(BControl.new(speed:0.25, density:0.0132, frequency:0.7041, amplitude:0.9388, entropy:1, color:0.0263, surface:0.7263, location:0.2275, position:0.7329, attack:0.001, release:0.001));
~livePresets26.add(BControl.new(speed:0.8351, density:0.3953, frequency:0.0526, amplitude:0.9211, entropy:0.7804, color:0.1316, surface:0.8973, location:0.5263, position:0.3426, attack:0.001, release:0.001));
~livePresets26.add(BControl.new(speed:0.5487, density:0.2833, frequency:0.8344, amplitude:0.9342, entropy:0, color:0, surface:0.2372, location:0.4342, position:0, attack:0.001, release:0.001));
~livePresets26.add(BControl.new(speed:0.8003, density:0.0658, frequency:0.7838, amplitude:0.9693, entropy:0.1842, color:0.1053, surface:0.9138, location:0.4079, position:0.9349, attack:0.001, release:0.001));
~livePresets26.add(BControl.new(speed:0.8605, density:0.0789, frequency:0.8039, amplitude:0.8421, entropy:0.4255, color:0.25, surface:0.5469, location:0.7287, position:0.2519, attack:0.001, release:0.001));

~livePresets28 = List.new;
~livePresets28.add(BControl.new(speed:0.1579, density:0.0263, frequency:0.5, amplitude:0.8684, entropy:0.8553, color:0.01, surface:0.5, location:0.5, position:0.5, attack:0.001, release:0.001));
~livePresets28.add(BControl.new(speed:0.1108, density:0.8569, frequency:0.9144, amplitude:0.75, entropy:0.3453, color:0.2763, surface:0.9707, location:0.1428, position:0.619, attack:0.001, release:0.001));
~livePresets28.add(BControl.new(speed:0.5656, density:0.3452, frequency:0.8431, amplitude:0.6842, entropy:0.9243, color:0.1579, surface:0.7101, location:0.076, position:0.1513, attack:0.001, release:0.001));
~livePresets28.add(BControl.new(speed:0.5423, density:0.1983, frequency:0.2966, amplitude:0.8289, entropy:0.8788, color:0.0641, surface:0.7444, location:0.5263, position:0.6202, attack:0.001, release:0.001));
~livePresets28.add(BControl.new(speed:0.2538, density:0.4405, frequency:0.9104, amplitude:0.6691, entropy:0.8586, color:0.0658, surface:0.0921, location:0.3816, position:0.658, attack:0.001, release:0.001));
~livePresets28.add(BControl.new(speed:0.0921, density:0.6699, frequency:0.7824, amplitude:0.8421, entropy:0.0395, color:0.1373, surface:0.5602, location:0.9535, position:0.7278, attack:0.001, release:0.001));
~livePresets28.add(BControl.new(speed:0.422, density:0.5078, frequency:0.2782, amplitude:0.9868, entropy:0.2791, color:0.1802, surface:0.8084, location:0.3844, position:0.4335, attack:0.001, release:0.001));
~livePresets28.add(BControl.new(speed:0.0809, density:0.4455, frequency:0.484, amplitude:0.8091, entropy:0.1528, color:0.0658, surface:0.724, location:0.7221, position:0.3289, attack:0.001, release:0.001));
~livePresets28.add(BControl.new(speed:0.99, density:0.99, frequency:0.01, amplitude:0.8091, entropy:0.01, color:0.0132, surface:0.3259, location:0.0193, position:0.0101, attack:0.001, release:0.001));

~livePresets47 = List.new;
~livePresets47.add(BControl.new(speed:0.6654, density:0.0591, frequency:0.1578, amplitude:0.8421, entropy:0.1427, color:0.3421, surface:0.1183, location:0.5395, position:0.1288, attack:0.001, release:0.001));
~livePresets47.add(BControl.new(speed:0.5351, density:0.7426, frequency:0.7381, amplitude:0.8026, entropy:0.2199, color:0.01, surface:0.624, location:0.5524, position:0.1662, attack:0.001, release:0.001));
~livePresets47.add(BControl.new(speed:0.9241, density:0.3883, frequency:0.3474, amplitude:0.8026, entropy:0.9848, color:0.01, surface:0.9304, location:0.3368, position:0.1181, attack:0.001, release:0.001));
~livePresets47.add(BControl.new(speed:0.1908, density:0.6188, frequency:0.5454, amplitude:0.8026, entropy:0.8321, color:0.01, surface:0.2904, location:0.4701, position:0.4217, attack:0.001, release:0.001));
~livePresets47.add(BControl.new(speed:0.5844, density:0.6982, frequency:0.6012, amplitude:0.8026, entropy:0.7645, color:0.01, surface:0.335, location:0.8119, position:0.4474, attack:0.001, release:0.001));
~livePresets47.add(BControl.new(speed:0.9224, density:0.5636, frequency:0.2311, amplitude:0.6447, entropy:0.5977, color:0.1053, surface:0.753, location:0.7482, position:0.5771, attack:0.001, release:0.001));
~livePresets47.add(BControl.new(speed:0.829, density:0.6269, frequency:0.8038, amplitude:0.6447, entropy:0.7655, color:0.3421, surface:0.627, location:0.2148, position:0.5771, attack:0.001, release:0.001));
~livePresets47.add(BControl.new(speed:0.1447, density:0.4146, frequency:0.1292, amplitude:0.6447, entropy:0.345, color:0.3421, surface:0.6145, location:0.3039, position:0.5789, attack:0.001, release:0.001));

~livepresets = List.new();
~livepresets.add(~livePresets12);
~livepresets.add(~livePresets13);
~livepresets.add(~livePresets36);
~livepresets.add(~livePresets38);
~livepresets.add(~livePresets24);
~livepresets.add(~livePresets26);
~livepresets.add(~livePresets28);
~livepresets.add(~livePresets47);

EpocEditor.view(~items, List());
EpocEditor.view(~items, List());

)