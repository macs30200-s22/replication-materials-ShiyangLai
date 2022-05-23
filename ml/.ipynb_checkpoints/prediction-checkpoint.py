"""
prediction tasks and models for MACSS 30100
author: shiyanglai
email: shiyanglai@uchicago.edu
"""

import keras
import tensorflow as tf
from utils import *
import models
from tensorflow.keras.models import Sequential, clone_model
from tensorflow.keras.layers import Dense, Dropout, GRU
from tensorflow.keras.optimizers import Adam
import sklearn


def binary_task(dataset, focal, in_system, model, optimizer=None, horizion=1, step_ahead=1, lookback=730, lag=7, verbose=0, **kwargs):
    # for comparasion purpose, I do the training on the whole dataset and the in_system dataset
    whole_dataset = dataset.copy()
    feature_num = whole_dataset.shape[1]
    # convert the format of the dataset, using historiy datapoints to predict n step ahead 
    whole_dataset = series_to_supervised(whole_dataset, n_in=lag, n_out=horizion)
    whole_dataset = drop_columns(whole_dataset, dataset, focal, horizion)
    whole_dataset = whole_dataset.values
    
    # using a rolling window to test the performance of the model
    if 'keras' in str(type(model)):
        model1 = clone_model(model)
        model1.compile(optimizer, loss='binary_crossentropy')
    
    real = []
    predicted_all = []
    if 'jump' in kwargs.keys():
        jump = kwargs['jump']
    else:
        jump = horizion
    
    for i in range(lookback, whole_dataset.shape[0]-step_ahead, jump):
        sup_x, sup_y = [], []
        if 'keras' in str(type(model)):
            train_X, test_X, train_y, test_y = seq2seq_X_y(whole_dataset, feature_num, i, lag, lookback, horizion)
            early_stop = keras.callbacks.EarlyStopping(monitor='loss', patience=10)
            model1.fit(train_X, train_y, epochs=kwargs['epochs'], batch_size=16, shuffle=False, callbacks=[early_stop], verbose=verbose)
            for step in range(step_ahead):
                train_X, test_X, train_y, test_y = seq2seq_X_y(whole_dataset, feature_num, i+step, lag, lookback, horizion)
                sup_x.append(model1.predict(test_X)[0])
                sup_y.append(test_y[0])
            predicted_all.append(sup_x)
            real.append(sup_y)
        else:
            train_X, test_X, train_y, test_y = simple_X_y(whole_dataset, feature_num, i, lookback, horizion)
            trained_model = model.fit(train_X, train_y)
            for step in range(step_ahead):
                train_X, test_X, train_y, test_y = simple_X_y(whole_dataset, feature_num, i+step, lookback, horizion)
                sup_x.append(trained_model.predict(test_X)[0])
                sup_y.append(test_y[0])
            predicted_all.append(sup_x)
            real.append(sup_y)
    

    in_sys_dataset = dataset[in_system]
    feature_num = in_sys_dataset.shape[1]
    in_sys_dataset = series_to_supervised(in_sys_dataset, n_in=lag, n_out=horizion)
    in_sys_dataset = drop_columns(in_sys_dataset, dataset[in_system], focal, horizion)
    in_sys_dataset = in_sys_dataset.values
    
    if 'keras' in str(type(model)):
        model2 = clone_model(model)
        model2.compile(optimizer, loss='binary_crossentropy')
    predicted_part = []
    for i in range(lookback, in_sys_dataset.shape[0]-step_ahead, jump):
        sup_x, sup_y = [], []
        if 'keras' in str(type(model)):
            train_X, test_X, train_y, test_y = seq2seq_X_y(in_sys_dataset, feature_num, i, lag, lookback, horizion)
            early_stop = keras.callbacks.EarlyStopping(monitor='loss', patience=10)
            model2.fit(train_X, train_y, epochs=kwargs['epochs'], batch_size=16, shuffle=False, callbacks=[early_stop], verbose=verbose)
            for step in range(step_ahead):
                train_X, test_X, train_y, test_y = seq2seq_X_y(in_sys_dataset, feature_num, i+step, lag, lookback, horizion)
                sup_x.append(model2.predict(test_X)[0])
                sup_y.append(test_y[0])
            predicted_part.append(sup_x)
        else:
            train_X, test_X, train_y, test_y = simple_X_y(in_sys_dataset, feature_num, i, lookback, horizion)
            trained_model = model.fit(train_X, train_y)
            for step in range(step_ahead):
                train_X, test_X, train_y, test_y = simple_X_y(in_sys_dataset, feature_num, i+step, lookback, horizion)
                sup_x.append(trained_model.predict(test_X)[0])
                sup_y.append(test_y[0])
            predicted_part.append(sup_x)
        
    print('Trained successfully!')
    return predicted_all, predicted_part, real



def regression_task(dataset, focal, in_system, model, optimizer=None, horizion=1, step_ahead=1, lookback=730, lag=7, verbose=0, **kwargs):
    # get the focal currency for later usage
    focal_currency = dataset['USD'+focal].values
    # for comparasion purpose, I do the training on the whole dataset and the in_system dataset
    whole_dataset = dataset.copy()
    feature_num = whole_dataset.shape[1]
    # convert the format of the dataset, using historiy datapoints to predict n step ahead 
    whole_dataset = series_to_supervised(whole_dataset, n_in=lag, n_out=horizion)
    whole_dataset = drop_columns(whole_dataset, dataset, focal, horizion)
    whole_dataset = whole_dataset.values
    
    # using a rolling window to test the performance of the model
    if 'keras' in str(type(model)):
        model1 = clone_model(model)
        model1.compile(optimizer, loss=tf.keras.losses.MeanSquaredError())
        
    real = []
    predicted_all = []
    if 'jump' in kwargs.keys():
        jump = kwargs['jump']
    else:
        jump = horizion
        
    for i in range(lookback, whole_dataset.shape[0]-step_ahead, jump):
        sup_x, sup_y = [], []
        if 'keras' in str(type(model)):
            train_X, test_X, train_y, test_y = seq2seq_X_y(whole_dataset, feature_num, i, lag, lookback, horizion)
            early_stop = keras.callbacks.EarlyStopping(monitor='loss', patience=10)
            model1.fit(train_X, train_y, epochs=kwargs['epochs'], batch_size=16, shuffle=False, callbacks=[early_stop], verbose=verbose)
            for step in range(step_ahead):
                train_X, test_X, train_y, test_y = seq2seq_X_y(whole_dataset, feature_num, i+step, lag, lookback, horizion)
                sup_x.append(model1.predict(test_X)[0])
                sup_y.append(test_y[0])
            predicted_all.append(sup_x)
            real.append(sup_y)
        elif type(model) == models.BenchmarkRegressor:
            model.fit(horizion)
            for step in range(step_ahead):
                sup_x.append(model.predict(focal_currency[:(i+step)]))
                sup_y.append(focal_currency[(i+step):(i+step+horizion)])
            predicted_all.append(sup_x)
            real.append(sup_y)
        else:
            train_X, test_X, train_y, test_y = simple_X_y(whole_dataset, feature_num, i, lookback, 1)
            trained_model = model.fit(train_X, train_y)
            for step in range(step_ahead):
                train_X, test_X, train_y, test_y = simple_X_y(whole_dataset, feature_num, i+step, lookback, horizion)
                sup_x.append(trained_model.predict(test_X)[0])
                sup_y.append(test_y[0])
            predicted_all.append(sup_x)
            real.append(sup_y)

    in_sys_dataset = dataset[in_system]
    feature_num = in_sys_dataset.shape[1]
    in_sys_dataset = series_to_supervised(in_sys_dataset, n_in=lag, n_out=horizion)
    in_sys_dataset = drop_columns(in_sys_dataset, dataset[in_system], focal, horizion)
    in_sys_dataset = in_sys_dataset.values
    
    if 'keras' in str(type(model)):
        model2 = clone_model(model)
        model2.compile(optimizer, loss=tf.keras.losses.MeanSquaredError())
    predicted_part = []
    for i in range(lookback, in_sys_dataset.shape[0]-step_ahead, jump):
        sup_x, sup_y = [], []
        if 'keras' in str(type(model)):
            train_X, test_X, train_y, test_y = seq2seq_X_y(in_sys_dataset, feature_num, i, lag, lookback, horizion)
            early_stop = keras.callbacks.EarlyStopping(monitor='loss', patience=10)
            model2.fit(train_X, train_y, epochs=kwargs['epochs'], batch_size=16, shuffle=False, callbacks=[early_stop], verbose=verbose)
            for step in range(step_ahead):
                train_X, test_X, train_y, test_y = seq2seq_X_y(in_sys_dataset, feature_num, i+step, lag, lookback, horizion)
                sup_x.append(model2.predict(test_X)[0])
                sup_y.append(test_y[0])
            predicted_part.append(sup_x)
        elif type(model) == models.BenchmarkRegressor:
            model.fit(horizion)
            for step in range(step_ahead):
                sup_x.append(model.predict(focal_currency[:(i+step)]))
                sup_y.append(focal_currency[(i+step):(i+step+horizion)])
            predicted_part.append(sup_x)
        else:
            train_X, test_X, train_y, test_y = simple_X_y(in_sys_dataset, feature_num, i, lookback, 1)
            trained_model = model.fit(train_X, train_y)
            for step in range(step_ahead):
                train_X, test_X, train_y, test_y = simple_X_y(in_sys_dataset, feature_num, i+step, lookback, horizion)
                sup_x.append(trained_model.predict(test_X)[0])
                sup_y.append(test_y[0])
            predicted_part.append(sup_x)
        
    print('Trained successfully!')
    return predicted_all, predicted_part, real