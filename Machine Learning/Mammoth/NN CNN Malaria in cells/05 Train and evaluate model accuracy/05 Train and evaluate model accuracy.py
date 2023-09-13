# -*- coding: utf-8 -*-
"""Neural network to find malaria.ipynb

Automatically generated by Colaboratory.  

https://colab.research.google.com
"""

import tensorflow
import tensorflow_datasets as tfds

malaria, info = tfds.load(name="malaria",
                          split="train",
                          with_info=True)

malaria

info

malaria = malaria.shuffle(20000).prefetch(tensorflow.data.experimental.AUTOTUNE)

malaria

import matplotlib.pyplot as pyplot

pyplot.figure(figsize=(30, 30))

num_of_images = 8

for index, feature in enumerate(malaria.take(num_of_images)):

  image = feature["image"].numpy()

  label = feature["label"].numpy()

  pyplot.subplot(4, 2, index + 1)

  pyplot.title("Class: " + str(label))

  pyplot.imshow(image)

pyplot.show()

dataset_length = 8000

new_size = 133

training_dataset_length = 0.8

X = int(dataset_length * training_dataset_length)

import numpy

colors = 3

training_images = numpy.zeros((X, new_size, new_size, colors))

training_labels = numpy.zeros(X)

y = dataset_length - X

testing_images = numpy.zeros((y, new_size, new_size, colors))

testing_labels = numpy.zeros(y)


for index, cell in enumerate(malaria.take(dataset_length)):

  image = tensorflow.image.resize(cell["image"],
                                  size=[new_size, new_size]).numpy() 

  label = cell["label"].numpy()

  if index < X:

    training_images[index] = image

    training_labels[index] = label

  else: 

    testing_images[index - X] = image

    testing_labels[index - X] = label

training_images.shape

training_labels.shape

testing_images.shape

testing_labels.shape

from tensorflow import keras

model = keras.Sequential()

model.add(keras.layers.Flatten(input_shape=(new_size,
                                            new_size,
                                            colors)))

model.add(keras.layers.Dense(200, activation="relu"))

model.add(keras.layers.Dense(150, activation="relu"))

model.add(keras.layers.Dense(8))

optimizer = tensorflow.keras.optimizers.Adam()

loss_function = tensorflow.keras.losses.SparseCategoricalCrossentropy(from_logits = True)

metrics = ["accuracy"]

model.compile(optimizer = optimizer,
              loss = loss_function,
              metrics = metrics)

number_of_training_loops = 5

model.fit(training_images, training_labels,
          epochs = number_of_training_loops)

testing_loss, testing_accuracy = model.evaluate(testing_images, 
                                                testing_labels,
                                                verbose = 2)