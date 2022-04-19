import numpy as np
import pandas as pd
import keras
from tensorflow.keras.models import Sequential, clone_model
from tensorflow.keras.layers import Dense, Dropout, GRU, LSTM
from tensorflow.keras.optimizers import Adam
import sklearn


class BenchmarkClassifier():
    def __init__(self):
        result = 0
    def fit(self, train_X, train_y):
        self.result = train_y[-1]
        return self
    def predict(self, test_y):
        return self.result

    
class BenchmarkRegressor():
    def __init__(self, lookback=1):
        self.lookback = lookback
        self.lookforward = 0
    def fit(self, lookforward=1):
        self.lookforward = lookforward
    def predict(self, history):
        return [np.mean(history[self.lookback:]) for i in range(self.lookforward)]


def grus(layer, out, activation, optimizer, **kwargs):
    regressor = Sequential()
    i = 0
    while i < layer-1:
        regressor.add(GRU(units=kwargs['gru'+str(i+1)], return_sequences=True, activation=activation))
        regressor.add(Dropout(kwargs['drop'+str(i+1)]))
        i += 1
    regressor.add(GRU(units=kwargs['gru'+str(i+1)], activation=activation))
    regressor.add(Dropout(kwargs['drop'+str(i+1)]))
    regressor.add(Dense(units=out, activation='sigmoid'))
    regressor.compile(optimizer=optimizer,
                         loss='binary_crossentropy')
    return regressor


def lstms(layer, out, activation, optimizer, **kwargs):
    regressor = Sequential()
    i = 0
    while i < layer-1:
        regressor.add(LSTM(units=kwargs['lstm'+str(i+1)], return_sequences=True, activation=activation))
        regressor.add(Dropout(kwargs['drop'+str(i+1)]))
        i += 1
    regressor.add(LSTM(units=kwargs['lstm'+str(i+1)], activation=activation))
    regressor.add(Dropout(kwargs['drop'+str(i+1)]))
    regressor.add(Dense(units=out, activation='sigmoid'))
    regressor.compile(optimizer=optimizer,
                         loss='binary_crossentropy')
    return regressor