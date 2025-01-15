<h1 align="center">
  <img src="readme/icon.png" alt="Icon" height="350" width="600">
</h1>
<p align="center">A Netflix Clone (as the name implies), made for learning purposes.</p>
<p align="center">If you want to see my other "serious" project, check <a href=https://github.com/BarbosaRT/Bossa>bossa</a></p>

# 

![login](readme/Login.png)  
![profile](readme/Profile.png)  
![home](readme/Home.png)  
![detail](readme/Detail.png)  
![video](readme/Video.png)  

# Requirements: 
- python >= 3.6 
- dart >= 2.17  
- [git](https://git-scm.com)

## Python (Only needed to make it function offline):  
```
pip install pytube, requests, json, unidecode
```
# Clone and Execute
Clone this repository:
```
git clone https://github.com/BarbosaRT/NetflixClone.git
```
Access the directory:
```
cd NetflixClone
```
You will need a TMDB api key, you can get one [here](https://developers.themoviedb.org/3/getting-started/introduction), after that replace the apiKey variable in lib/core/api/content_controller.dart and in lib/scripts/api.py

Now install the dependencies:
```
flutter pub get
```
And run:
```
flutter run
```


# Extras
- The UI works better in 1366x768, when I made this clone I didn't need it to be responsive, so I lock it to my monitor resolution.
- Original smooth_scroll by [dezso15](https://gitlab.com/dezso15/smoothscrollweb)   
- Data Sources: TMDB, uNoGs      
