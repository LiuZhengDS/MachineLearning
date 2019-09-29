# -*- coding: utf-8 -*-
"""
Created on Tue Feb 26 09:34:48 2019

@author: cassie
"""

import numpy as np
import math,random
from numpy.linalg import cholesky
import matplotlib.pyplot as plt

def stumpClassify(X, j, thresh, ineq):
                                    # X：dataset，j：attribute
                                    # thresh：thresh，ineq：less than (lt) or greater than (gt)
    pred = np.ones(X.shape[0])
    if ineq == 'lt':
        pred[X[:, j] <= thresh] = 0
    else:
        pred[X[:, j] > thresh] = 0
    return pred

def buildStump(X, y, w):
                            # X：dataset，y：labels
                            # w：sample weight, initialized by np.ones(N)/N
    N, d = X.shape
    minErr = np.inf

    stepSize = 0.01 #degree of ex-haustive search
    bestStump,bestClass = {},np.ones(N)

    for j in range(d):
        rangeMin, rangeMax = X[:, j].min(), X[:, j].max()
        numStep = math.ceil((rangeMax-rangeMin)/stepSize)+1
        for i in range(-1, numStep+1):
            thresh = rangeMin + i*stepSize
            for ineq in ['lt', 'gt']:
                pred = stumpClassify(X, j, thresh, ineq)
                errLabel = np.zeros(N)
                errLabel[pred != y] = 1
                weightedErr = w.dot(errLabel)
                if minErr > weightedErr:
                    minErr = weightedErr
                    bestClass = pred
                    bestStump['dim'] = j
                    bestStump['ineq'] = ineq
                    bestStump['thresh'] = thresh
    return bestStump, minErr, bestClass

def adaBoost_train(X, y, n_iter):
    """构建adaboost算法，在构建的时候会考虑权重，训练出来的基学习器在预测的时候是不会对样本加权的"""
    weak_class_arr = []  #弱分类器
    N = np.shape(X)[0]
    w = np.ones(N)/ N  #初始化样本权重，均匀分布
    agg_class_est = np.zeros(N)  # f(x)在训练集上的结果
    thresh = np.zeros(N)

    for i in range(n_iter):
        best_stump, error, bestClass  = buildStump(X, y, w)  #基分类器
        #beta = 0.5 * np.log((1-error) / max(error, 1e-16))  #防止error为0
        beta= error/ (1-error)

        #expon = np.multiply(-1 * beta * np.mat(y).T, bestClass)  # shape: N * 1
        expon=np.power(beta,1-abs(bestClass-y))
        w = np.multiply(w, expon)  # shape: N * 1
        w /= w.sum()  #得到下一轮的权重

        best_stump['w'] = w
        best_stump['beta'] = beta
        weak_class_arr.append(best_stump)  #记录学习结果

        #agg_class_est += beta * bestClass
        #agg_error = np.multiply(np.sign(agg_class_est) != np.mat(y).T, np.ones((N,1)))  #累计错误率，前者是判断，得到的是true,false，乘以1可以得到数字1，0

        agg_class_est += np.log(1/beta) * bestClass
        thresh +=0.5 * np.log(1/beta) * np.ones(N)
        pred=np.zeros(N)
        pred[agg_class_est>=thresh]=1

        #agg_error = np.multiply(pred != y, np.ones((N,1)))  #累计错误率，前者是判断，得到的是true,false，乘以1可以得到数字1，0
        #error_rate = agg_error.sum() / N  #平均错误率
        errLabel = np.zeros(N)
        errLabel[pred != y] = 1
        error_rate=sum(errLabel)/N
        if error_rate == 0:
            break
    return weak_class_arr,error_rate

def adaBoost_test(weak_class_arrs,test):
    N = np.shape(test)[0]
    agg_class_est = np.zeros(N)  # f(x)在训练集上的结果
    thresh = np.zeros(N)
    for weak_class_arr in weak_class_arrs:
        bestClass = stumpClassify(test, weak_class_arr['dim'], weak_class_arr['thresh'], weak_class_arr['ineq'])
        agg_class_est += np.log(1/weak_class_arr['beta']) * bestClass
        thresh +=0.5 * np.log(1/weak_class_arr['beta']) * np.ones(N)
    pred=np.zeros(N)
    pred[agg_class_est>=thresh]=1
    return pred
'''
N=100
T=100
# 二维正态分布
mu = np.array([[0, 0]])
Sigma = np.array([[1, 0], [0, 1]])
R = cholesky(Sigma)
c1 = np.dot(np.random.randn(N, 2), R) + mu
#plt.subplot(144)
# 注意绘制的是散点图，而不是直方图
plt.plot(c1[:,0],c1[:,1],'+')
#plt.show()

mu = np.array([[2, 0]])
R = cholesky(Sigma)
c2 = np.dot(np.random.randn(N, 2), R) + mu
#plt.subplot(144)

# 注意绘制的是散点图，而不是直方图
plt.plot(c2[:,0],c2[:,1],'_')
plt.show()

X=np.concatenate((c1,c2))
y=np.concatenate((np.ones(N),np.zeros(N)))
w=np.ones(N*2)/(N*2)
#bestStump, minErr, bestClass = buildStump(X, y, w)
weak_class_arr,error_rate=adaBoost_train(X,y,T)

'''
train=np.loadtxt('fashion57_train.txt',dtype=np.float64,delimiter=',')
y_train=np.concatenate((np.ones(32),np.zeros(28)))
test=np.loadtxt('fashion57_test.txt',dtype=np.float64,delimiter=',')
y_test=np.concatenate((np.ones(195),np.zeros(205)))

w=np.ones(60)/(60)
#bestStump, minErr, bestClass = buildStump(train, y_train, w)

errors=[]
x=[i for i in range(1,15)]
x.extend([j for j in range(15,200,5)])
for T in x:
    print(T)
    weak_class_arr,error_rate=adaBoost_train(train, y_train,T)

    pred = adaBoost_test(weak_class_arr,test)
    errLabel = np.zeros(400)
    errLabel[pred != y_test] = 1
    error=sum(errLabel)/400
    errors.append(error)

plt.plot(x, errors, color='blue', label='test error')
plt.xlabel('T')
plt.ylabel('test error')
plt.show()

print('showing training sample highest weights...')
T=x[errors.index(min(errors))]
print(T)
weak_class_arr,error_rate=adaBoost_train(train, y_train,T)
final_w=weak_class_arr[len(weak_class_arr)-1]['w']
h1=train[list(final_w[0:32]).index(max(final_w[0:32])),:]
h2=train[32+list(final_w[32:]).index(max(final_w[32:])),:]
print(h1)
print(h2)

print('learning curve...')
learning_curve=[]
for n in [2,4,6,10,15,20]:
    print(n)
    new_train=np.concatenate((random.sample(list(train[0:32]),n),random.sample(list(train[32:]),n)))
    new_y_train=np.concatenate((random.sample(list(y_train[0:32]),n),random.sample(list(y_train[32:]),n)))
    weak_class_arr,error_rate=adaBoost_train(new_train, new_y_train,T)
    pred = adaBoost_test(weak_class_arr,test)
    errLabel = np.zeros(400)
    errLabel[pred != y_test] = 1
    error=sum(errLabel)/400
    learning_curve.append(error)

plt.plot([2,4,6,10,15,20], learning_curve, color='blue', label='test error')
plt.xlabel('sample size n')
plt.ylabel('test error')
plt.show()
'''
pred = stumpClassify(test, bestStump['dim'], bestStump['thresh'], bestStump['ineq'])
errLabel = np.zeros(400)
errLabel[pred != y_test] = 1
w=np.ones(400)/(400)
weightedErr = w.dot(errLabel)
'''
