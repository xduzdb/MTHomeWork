# MNIST模型设置指南

## 📥 获取MNISTClassifier.mlmodel文件

### 方式1：下载预训练模型
1. 访问 [Apple Developer - Core ML Models](https://developer.apple.com/machine-learning/models/)
2. 下载MNIST相关的模型文件
3. 重命名为 `MNISTClassifier.mlmodel`

### 方式2：使用Create ML训练
```python
import coremltools as ct
import tensorflow as tf
from tensorflow import keras

# 加载MNIST数据集
(x_train, y_train), (x_test, y_test) = keras.datasets.mnist.load_data()

# 预处理数据
x_train = x_train.astype('float32') / 255.0
x_test = x_test.astype('float32') / 255.0
x_train = x_train.reshape(-1, 28, 28, 1)
x_test = x_test.reshape(-1, 28, 28, 1)

# 创建模型
model = keras.Sequential([
    keras.layers.Conv2D(32, 3, activation='relu'),
    keras.layers.MaxPooling2D(),
    keras.layers.Flatten(),
    keras.layers.Dense(128, activation='relu'),
    keras.layers.Dense(10, activation='softmax')
])

# 编译和训练
model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])
model.fit(x_train, y_train, epochs=5)

# 转换为Core ML
mlmodel = ct.convert(model,
                    inputs=[ct.ImageType(name="image",
                                        shape=(1, 28, 28, 1))])
mlmodel.save("MNISTClassifier.mlmodel")
```

### 方式3：使用在线模型
您可以从以下网址下载：
- [GitHub - MNIST Core ML Models](https://github.com/topics/mnist-coreml)
- [Hugging Face Model Hub](https://huggingface.co/models?library=coreml)

## 🚀 添加模型到项目

1. **拖拽文件到Xcode**
   - 将下载的 `MNISTClassifier.mlmodel` 拖拽到Xcode项目中
   - 确保选择 "Copy items if needed"
   - 确保选择 "Add to target: HomeWork"

2. **验证添加**
   - 在项目导航器中应该能看到模型文件
   - 模型文件应该显示为蓝色图标

3. **编译测试**
   - 按 `Cmd+B` 编译项目
   - 确保没有错误

## ⚠️ 注意事项

- 模型文件大小通常在几MB到几十MB
- 确保模型输入格式为28x28灰度图像
- 输出应该是10个类别的概率分布（0-9数字）

## 🧪 测试建议

添加模型后，运行应用：
1. 打开"手写数字识别"功能
2. 在黑色区域手写数字
3. 点击"识别"按钮
4. 查看识别结果和置信度 