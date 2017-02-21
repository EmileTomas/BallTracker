%load image
logo=imread('logo.png');
detected_image=imread('1.jpg');

%change image to gray 
logo_gray=rgb2gray(logo);
detected_image_gray=rgb2gray(detected_image);

%detect SURF features
logo_points=detectSURFFeatures(logo_gray);
detected_image_points=detectSURFFeatures(detected_image_gray);

% get match point pairs
[logo_features,logo_valid_points]=extractFeatures(logo_gray,logo_points);
[detected_image_features,detected_image_valid_points]=extractFeatures(detected_image_gray,detected_image_points);
indexPairs=matchFeatures(logo_features,detected_image_features);

%show the result
logo_matchedPoints=logo_valid_points(indexPairs(:,1),:);
detected_image_matchedPoints=detected_image_valid_points(indexPairs(:,2),:);
figure;showMatchedFeatures(logo,detected_image,logo_matchedPoints,detected_image_matchedPoints);
