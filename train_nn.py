import torch
import torch.nn as nn
from define_nn import MNISTHardwareNet
import torch.optim as optim
from torchvision import datasets, transforms
from torch.utils.data import DataLoader

def train_model():
    # use transform to flatten 28x28 -> 784
    transform = transforms.Compose([
        transforms.RandomAffine(degrees=10, translate=(0.15, 0.15), scale=(0.85, 1.15)),
        transforms.ToTensor(),
        transforms.Lambda(lambda x: torch.flatten(x))
    ])

    # download+load MNIST
    train_dataset = datasets.MNIST(root='./data', train=True, download=True, transform=transform)
    train_loader = DataLoader(train_dataset, batch_size=64, shuffle=True)

    model = MNISTHardwareNet()

    # loss function
    criterion = nn.CrossEntropyLoss()

    # Optimizer (to update weights)
    optimizer = optim.Adam(model.parameters(), lr=0.001)

    # Q1.15 Limits for PyTorch Clamping
    q1_15_max = 32767.0 / 32768.0
    q1_15_min = -1.0

    epochs = 40
    model.train()
    print("Starting Training...")
    for epoch in range(epochs):
        for images, labels in train_loader:

            # clear out last batch gradient accumulators
            optimizer.zero_grad()

            # forward pass
            outputs = model(images)

            # loss 
            loss = criterion(outputs, labels)

            # backward pass
            loss.backward()

            # update weights
            optimizer.step()

            # for weights to stay inside Q1.15 hardware limits
            with torch.no_grad():
                for param in model.parameters():
                    param.clamp_(q1_15_min, q1_15_max)

        print(f"Epoch {epoch+1} Complete! Loss: {loss.item():.4f}")

    # load test MNIST
    test_dataset = datasets.MNIST(root='./data', train=False, download=True, transform=transform)
    test_loader = DataLoader(test_dataset, batch_size=1000, shuffle=False)

    correct_guesses = 0
    total_images = 0

    model.eval()
    with torch.no_grad():
        for images, labels in test_loader:
            # forward
            outputs = model(images)

            #index of highest score
            _, predicted = torch.max(outputs, 1)

            # add batch size to total
            total_images += labels.size(0)

            # count predictions vs labels correct
            correct_guesses += (predicted == labels).sum().item()

    # Calculate and print the final percentage
    accuracy = 100 * correct_guesses / total_images
    print(f"Final Hardware Model Accuracy: {accuracy:.2f}%")

    torch.save(model.state_dict(), 'mnist.pth')

    return model

if __name__ == "__main__":
    train_model()