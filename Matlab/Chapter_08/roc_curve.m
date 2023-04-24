rng(42)
size = 100;
y = rand(1,size)>0.5;
pred = rand(1,size);

thresholds = 0.0: 0.01: 1;

tpr_array = [];
fpr_array = [];

for treshold = thresholds
    actual_positive = y == 1;
    actual_negative = y == 0;

    predicted_positive = pred >= treshold;
    predicted_negative = pred < treshold;
    
    %Ideal case
    %predicted_positive = actual_positive;
    %predicted_negative = actual_negative;

    tp = sum((predicted_positive + actual_positive)==2);
    tn = sum((predicted_negative + actual_negative)==2);

    fp = sum((predicted_positive + actual_negative)==2);
    fn = sum((predicted_negative + actual_positive)==2);

   
    % Confusion Matrix
    cm = [tp fn; fp tn];
    
    tpr = tp / (tp + fn);
    fpr = fp / (fp + tn);

    tpr_array = [tpr_array tpr];
    fpr_array = [fpr_array fpr];
end

scatter(fpr_array, tpr_array)
xlim([-0.05 1.05])
ylim([-0.05 1.05])
