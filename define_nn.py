import torch 
import torch.nn as nn
import torch.nn.functional as F

class MNISTHardwareNet(nn.Module):
    def __init__(self):
        super().__init__() # initialize base PyTorch module

        self.layer1 = nn.Linear(784, 64)
        self.layer2 = nn.Linear(64, 32)
        self.layer3 = nn.Linear(32, 10)
        self.layer4 = nn.Linear(10, 10)

    def forward(self, x):

        # Layer 1
        x = self.layer1(x)
        x = F.relu(x)
        x = x.clamp(0.0, 0.9999)

        # Layer 2
        x = self.layer2(x)
        x = F.relu(x)
        x = x.clamp(0.0, 0.9999)

        # Layer 3
        x = self.layer3(x)
        x = F.relu(x)
        x = x.clamp(0.0, 0.9999)

        # Layer 4
        x = self.layer4(x)

        return x

        