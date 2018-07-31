from keras.models import Model, Sequential, load_model
from keras.optimizers import Nadam, SGD, Adam
from keras.layers import Conv2D, MaxPooling2D, Input, Conv1D, MaxPooling3D, Conv3D, ConvLSTM2D, LSTM, AveragePooling2D
from keras.layers import Input, LSTM, Embedding, Dense, LeakyReLU, Flatten, Dropout, SeparableConv2D, GlobalAveragePooling3D
from keras.layers import TimeDistributed, BatchNormalization
from keras import optimizers
from keras.callbacks import EarlyStopping
from keras import regularizers

class ResearchModels():
    def __init__(self, model, frames, dimensions, saved_model=None, print_model=False):
        """
        `model` = one of:
            lstm
            lrcn
            mlp
            conv_3d
            c3d
        `frames` = the number of frames of satelite images in a year
        `dimensions` = the dimensions of the picture (channel last)
        `saved_model` = the path to a saved Keras model to load
        """
        
        # Set defaults.
        self.frames = frames
        self.saved_model = saved_model
        self.image_dim = tuple(dimensions)
        self.input_shape = (frames, ) + tuple(dimensions)
        self.print_model = print_model

        # Set the metrics. Only use top k if there's a need.
        metrics = ['mean_absolute_error']

        # Get the appropriate model.
        if self.saved_model is not None:
            print("Loading model %s" % self.saved_model)
            self.model = load_model(self.saved_model)
        	
        elif model == 'CNN_LSTM':
            print("Loading Model.")
            self.model = self.CNN_LSTM()
        elif model == 'SepCNN_LSTM':
            print("Loading Model.")
            self.model = self.SepCNN_LSTM()
        elif model == 'CONVLSTM':
            print("Loading Model.")
            self.model = self.CONVLSTM()
        elif model == 'CONV3D':
            print("Loading Model")
            self.model = self.CONV3D()
        elif model == 'CONVLSTM_CONV3D':
            print("Loading Model")
            self.model = self.CONVLSTM_CONV3D()
        else:
            print("Unknown network.")
            sys.exit()
			
        # Now compile the network.
        optimizer = Adam()
        self.model.compile(loss='mse', optimizer=optimizer, metrics=metrics)
		
        if self.print_model == True:
            print(self.model.summary())
                           
                           
    def CNN_LSTM(self):

        frames_input = Input(shape=self.input_shape)
        vision_model = Sequential()
        vision_model.add(Conv2D(64, (1, 2), activation='relu', padding='same', input_shape=self.image_dim))
        vision_model.add(BatchNormalization())
        vision_model.add(MaxPooling2D((1, 2)))
        vision_model.add(Flatten())
        vision_model.add(BatchNormalization())
        encoded_frame_sequence = TimeDistributed(vision_model)(frames_input) # the output will be a sequence of vectors
        encoded_video = LSTM(256, activation='tanh', return_sequences=True)(encoded_frame_sequence)  # the output will be a vector
        
        fc2 = Dense(64, activation='relu', kernel_regularizer=regularizers.l2(0.05))(encoded_video)
        out = Flatten()(fc2)
        out = Dropout(0.5)(out)
        output = Dense(1, activation='relu')(out)
        CNN_LSTM = Model(inputs=frames_input, outputs=output)
        return CNN_LSTM
	
	
    def SepCNN_LSTM(self):

        frames_input = Input(shape=self.input_shape)
        
        vision_model = Sequential()
        vision_model.add(SeparableConv2D(64, (1, 2), activation='relu', padding='same', input_shape=self.image_dim))
        vision_model.add(BatchNormalization())
        vision_model.add(MaxPooling2D((1, 2)))
        vision_model.add(Flatten())
        vision_model.add(BatchNormalization())
        encoded_frame_sequence = TimeDistributed(vision_model)(frames_input) # the output will be a sequence of vectors
        encoded_video = LSTM(256, activation='tanh', return_sequences=True)(encoded_frame_sequence)  # the output will be a vector
        
        fc2 = Dense(64, activation='relu', kernel_regularizer=regularizers.l2(0.05))(encoded_video)
        out = Flatten()(fc2)
        out = Dropout(0.5)(out)
        output = Dense(1, activation='relu')(out)
        CNN_LSTM = Model(inputs=frames_input, outputs=output)
        
        return CNN_LSTM
	
	
    def CONVLSTM(self):

        CONVLSTM = Sequential()
        CONVLSTM.add(ConvLSTM2D(filters=64, kernel_size=(1, 2),
                   input_shape=self.input_shape,
                   padding='same', return_sequences=True,
                   activation='relu'))
        CONVLSTM.add(ConvLSTM2D(filters=32, kernel_size=(1, 2),
                   padding='same', return_sequences=True,
                   activation='relu'))
        CONVLSTM.add(ConvLSTM2D(filters=32, kernel_size=(1, 2),
                   padding='same', return_sequences=True,
                   activation='relu'))
        CONVLSTM.add(BatchNormalization())
        CONVLSTM.add(Flatten())

        CONVLSTM.add(Dense(32, activation='relu'))
        CONVLSTM.add(Dropout(0.5))
        CONVLSTM.add(Dense(1, activation='relu'))
		
        return CONVLSTM
	
    def CONV3D(self):

        CONV3D = Sequential()
        CONV3D.add(Conv3D(filters=64, kernel_size=(1, 2, 1), input_shape=self.input_shape,
                   padding='same', activation='relu'))
        CONV3D.add(Conv3D(filters=32, kernel_size=(1, 2, 1),
                   padding='same', activation='relu'))
        CONV3D.add(Conv3D(filters=32, kernel_size=(1, 2, 1),
                   padding='same', activation='relu'))

        CONV3D.add(MaxPooling3D(pool_size=(2, 1, 1), strides=(1, 1, 1),
                        border_mode='valid'))
    
        CONV3D.add(BatchNormalization())
        CONV3D.add(Flatten())

        CONV3D.add(Dense(32, activation='relu'))
        CONV3D.add(Dropout(0.5))
        CONV3D.add(Dense(1, activation='relu'))

        return CONV3D

    def CONVLSTM_CONV3D(self):	
        
        CONVLSTM_CON3D = Sequential()
        CONVLSTM_CON3D.add(ConvLSTM2D(filters=64, kernel_size=(1, 2),
                   input_shape=self.input_shape,
                   padding='same', return_sequences=True,
                   activation='relu'))
        CONVLSTM_CON3D.add(ConvLSTM2D(filters=32, kernel_size=(1, 2),
                   padding='same', return_sequences=True,
                   activation='relu'))
        CONVLSTM_CON3D.add(Conv3D(filters=32, kernel_size=(1, 1, 2),
                   padding='same', activation='relu'))
        CONVLSTM_CON3D.add(MaxPooling3D(pool_size=(1, 1, 2)))
        CONVLSTM_CON3D.add(Flatten())
        CONVLSTM_CON3D.add(BatchNormalization())

        CONVLSTM_CON3D.add(Dense(64, activation='relu'))
        CONVLSTM_CON3D.add(Dropout(0.5))
        CONVLSTM_CON3D.add(Dense(1, activation='relu'))
        
        return CONVLSTM_CON3D
