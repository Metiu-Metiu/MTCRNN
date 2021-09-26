# Quick(ish) Start

1. There is a small dataset in Quickstart/.  Let's say you unzip it and put it in /scratch/QuickStart/RegularPopsRandomPitch_16k

2. Install nvidia docker. To check:

   ```
   nvidia-docker version
   ```

3. Next create you docker container for running the RNN. Navigate to the /docker folder. You may need to edit the 1st line of the Docker file to get a pytorch version compatible with your graphics card.  Then  run:

   ```
   docker image build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) --file Dockerfile --tag your_username:mtcrnn ../
   ```

4. Back in the RNN project directory, edit runscripts/quickstart.docker.run_tg.sh to run just a couple of steps if you just want to check for runability . Then:

   ```
   chmod +x runscripts/quickstart.docker.pops.run_tg.sh
   ```

5. Fire up your docker container:

   ```bash
   docker run --ipc=host --gpus "device=0" -it --name quickstart -v $(pwd):/MTCRNN.Fork -v /scratch/QuickStart:/mydata your_username:mtcrnn
   ```

6. Train:

   ```
   runscripts/quickstart.docker.pops.run_tg.sh -t
   ```

7. Create an array of conditioning parameter values to drive the RNN during generation using genParam/quickstart.ipynb. Put the generated .npy file in getParams/run/QuickStart_pops (because this is where the runscript is set to look). 

8. Generate:

   ```
   runscripts/quickstart.docker.run -g
   ```

Note: The quick start example uses a single 'tier' RNN that learns to generate the sample-by-sample audio.

<hr>


Check out more texture datasets from [syntex.sonicthings.org](). 

They can all use the paramManager metadata file format that this code uses for data loading.

<hr>

# Multi-tier Conditional RNN

A generative model for audio that is driven by conditioning at different timescales.  
Before running, copy [paramManager](https://github.com/muhdhuz/paramManager) repository into the root of this repo.

**Recommended project structure**  

- `train.py`: Main script for training and saving model
- `generate.py` : A script for generating with pre-trained model
- /network
    - `config.py` : Training/generation options
    - `networks.py` : Modules for network architecture
    - `model.py` : Calculate loss and optimization, higher level model functions
    - `sampling.py` : Functions to sample from output distribution of network
- /dataloader
    - `dataloader.py` : Preparing dataset, dataloading utilities, including calling transforms on data
    - `transforms.py` : Utilities for data transformations
- /utils
    - `myUtils.py` : Some useful routines
- /paramManager
    - `paramManager.py` : A library to handle param files, do resampling     

**Dependencies**  
* PyTorch >= 1.0
* [paramManager](https://github.com/muhdhuz/paramManager)
* PySoundfile >= 0.9 for loading audio files
  

**Authors**  
* Muhammad Huzaifah
* Lonce Wyse

**Acknowledgement**
* Organisation and functional structure generally inspired by [Golbin's WaveNet repo](https://github.com/golbin/WaveNet).

  

## Important Config Options
Each tier is an individual model that is trained independently. First decide which parameters (or audio) are to be generated and which are to be used as conditioning variables.  
List the generation parameters under **generate** and the corresponding number of input channels as **gen_size**. List the conditioning parameters under **prop** and the corresponding number of channels as **cond_size**. Specify the **sample_rate** for the tier. **data_dir** and **param_dir** point to the directory containing the data files and parameter files respectively. Models will be saved in **output_dir**. Please consult config file for more options and the below for some recipes to get started. 

## Training
![](figures/mtcrnn_training.png)

**Training frame-level tier (parameters only)**  
For the below teacher forcing rate (TFR) is held constant at 0.5 throughout training duration.  
Tier 3:    

```bash
python3 train.py --hidden_size 300 --batch_size 16 --data_dir data/audio --param_dir data/param --generate rmse centroid pitch --prop fill --gen_size 3 --cond_size 1 --output_dir tier3  --sample_rate 125 --seq_len 1000 --num_steps 4000 --checkpoint 1000 --tfr 0.5
```
Tier 2:    
```bash
python3 train.py --hidden_size 500 --batch_size 16 --data_dir data/audio --param_dir data/param --generate mfcc0 mfcc1 mfcc2 mfcc3 mfcc4 mfcc5 mfcc6 mfcc7 mfcc8 mfcc9 mfcc10 mfcc11 mfcc12 --prop rmse centroid pitch --gen_size 13 --cond_size 3 --output_dir tier2 --sample_rate 500 --seq_len 2000 --num_steps 6000 --checkpoint 2000 --tfr 0.5
```

**Training sample-level tier (audio + parameters)**  
If unspecified, **generate** option defaults to "audio". Use **gen_size** 1 if output audio are mu-law encoded else number of mu-law channels (default: 256) if using **one-hot** option. Currently audio generation cannot be mixed with generation of other parameters but parameters can still be used as conditional inputs. If **ss** is supplied in addition to **tfr**, scheduled sampling is used, the TFR is linearly decreased over the training duration strating from **tfr** and ending at **ss**.    
Tier 1:     
```bash
python3 train.py --hidden_size 800 --batch_size 16 --data_dir data/audio --param_dir data/param --prop mfcc0 mfcc1 mfcc2 mfcc3 mfcc4 mfcc5 mfcc6 mfcc7 mfcc8 mfcc9 mfcc10 mfcc11 mfcc12 --cond_size 13 --gen_size 1 --output_dir tier1  --num_steps 50000 --checkpoint 5000 --tfr 0.8 --ss 0
```

**Resuming training from checkpoint**  
The following directories are automatically created when the model is trained:  
-  output_dir    
    - log    
        - args.txt  
        - traininglog.txt    
    - model
        - model_1000    
        - model_2000      

Models are automatically saved according to the following naming convension: model_step. "args.txt" holds the training arguments used in the run, while "traininglog.txt" holds the training losses over steps. To resume training from a checkpoint, just need to supply the model directory using **model_dir** and the **step**. Following will start training from model under "tier3" directory from step 2000.    
Tier 1:     
```bash
python3 train.py --hidden_size 300 --batch_size 16 --data_dir data/audio --param_dir data/param --generate rmse centroid pitch --prop fill --gen_size 3 --cond_size 1 --output_dir tier3  --sample_rate 125 --seq_len 1000 --num_steps 4000 --checkpoint 1000 --model_dir tier3/model --step 2000
```

## Generate
![](figures/mtcrnn_generation.png)

Generation has 3 modes of conditioning given by **paramvect** option:  

* *self* (default): taken from priming data file  
* *external*: manually provide a numpy array of shape [batch,length,features]  
* *none*: no conditioning    

**Generate with self conditioning**  
Below case will output synthesized rmse, spec centroid and pitch, using fill as a conditional control parameter. (seq_len-length) samples are used for priming. Requires a trained model found in **model_dir** and defined by **step**. Since self conditioning is specified, real fill values are taken from the data. **save** option is there if want to save the output. Audio generated is automatically saved as a wav file. **sample_rate** refers to the sample rate of the model (number of param/audio values per sec of audio).  
For conditioning with params taken randomly from somewhere in the dataset, supply **data_dir**:
```bash
python3 generate.py --hidden_size 300 --batch_size 1 --seq_len 1325 --length 1200 --param_dir data/param --generate rmse centroid pitch --prop fill --gen_size 3 --cond_size 1 --model_dir output/tier3/model --step 4000 --sample_rate 125 --paramvect self --save --data_dir data/audio
```
For conditioning from a specific file starting from a specific time (in sec) use **seed** and **seed_start**:
If **data_dir** is given conditioning params are taken randomly from somewhere in the dataset. Instead if **seed** is provided the params are taken from the seed file starting from the time given by dataset or seed audio file. 
```bash
python3 generate.py --hidden_size 300 --batch_size 1 --seq_len 1325 --length 1200 --param_dir data/param --generate rmse centroid pitch --prop fill --gen_size 3 --cond_size 1 --model_dir output/tier3/model --step 4000 --sample_rate 125 --paramvect self --save --seed data/audio/ZOOM0001.wav --seed_start 1.5
```

**Generate with external conditioning**  
Below case will output synthesized audio, using mfcc{0-12} as a conditional control parameters. (seq_len-length) samples are used for priming. Requires a trained model found in **model_dir** and defined by **step**. External conditioning requires additional keywords **external array** pointing to a saved numpy array .npy file containing the conditioning values and **external_sr**, the original sample rate for this set of conditional values. Values will be upsampled automatically from **external_sr** to **sample_rate**. Output filename given by **out**.        
```bash
python3 generate.py --hidden_size 800 --batch_size 1 --seq_len 80001 --length 80000 --param_dir data/param --generate audio --prop mfcc0 mfcc1 mfcc2 mfcc3 mfcc4 mfcc5 mfcc6 mfcc7 mfcc8 mfcc9 mfcc10 mfcc11 mfcc12 --gen_size 3 --cond_size 1 --model_dir output/tier1/model --step 50000 --sample_rate 16000 --data_dir data/audio --paramvect external --external_array mfcc.npy --external_sr 500 --out generated_audio
```

**Unconditional generation**  
For **paramvect** "none", leave **prop** as blank and set **cond_size** to 0.  
```bash
python3 generate.py --hidden_size 300 --batch_size 1 --seq_len 1325 --length 1200 --param_dir data/param --generate rmse centroid pitch --gen_size 3 --cond_size 0 --model_dir output/tier3/model --step 4000 --data_dir data/audio --paramvect none --sample_rate 125 --save
```

**Priming with random numbers**  
For the above, priming is done with (seq_len-length) samples, either from **data_dir** or **seed**. If instead want to prime with random numbers add **rand_prime** keyword. If consistent random numbers are desired then also provide a random seed using **rand_seed**. The length for the random primer is still (seq_len-length) samples. 

```bash
python3 generate.py --hidden_size 300 --batch_size 1 --seq_len 1325 --length 1200 --param_dir data/param --generate rmse centroid pitch --gen_size 3 --cond_size 0 --model_dir output/tier3/model --step 4000 --data_dir data/audio --paramvect none --sample_rate 125 --rand_prime --seed 14
```

## Architectures  
Several different network architectures are provided with the code. These can be chosen with the **net** argument. For standard use only --net 0 is needed. If you are feeling adventurous feel free to try the other networks {1-5}. Network 6 is a legacy option for compatibility with old models. This option should NOT be used. Please consult config.py and network.py for descriptions of each network. There is also a **plstm** option to use [phased lstm](https://arxiv.org/abs/1610.09513) in place of gru. This works in principle but the optimum plstm parameters are unknown.

## Docker  

Perhaps the most reliable way to run this code is in a docker environment. The file for creating the environment is in the folder /docker. To create the image: 

```bash
docker image build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) --file Dockerfile --tag foo:mtcrnn ../
```

Then to run a container from your ProjectDirectory:

```
docker run --ipc=host --gpus "device=0" -it -v $(pwd):/ProjectDirectory -v /path-to-your-data-folder:/mydata foo:mtcrnn
```

The  name '/mydata' will refer to the path-to-your-data-folder in the container, and is used in the runscript (see below).

## genParams  

The genParams/ folder has some notebooks that you can use to generate .npy files of conditioning parameters for controlling the RNN during generation. The runscript (see below) uses such files for generating audio. The files are just arrays of numbers, so your runscript (or generation code) must know how many there are and what they mean (which parameters in the metadata files they correspond to).

## Runscript  

runscripts/ run_tg.sh [-t, -g] for training and/or generating does just about everything for a basic run. Set the parameters you want in the script and run.





