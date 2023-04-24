rng(42)
size = 100;
y = rand(1, size)>0.5;
pred = rand(1, size);

thresholds = 0.0: 0.01: 1;

tpr_array = [];
fpr_array = [];

for threshold = thresholds
    %threshold = 0.5;
    
    actual_positive = y == 1;
    actual_negatives = y == 0;
    
    %predicted_positives = pred >= threshold;
    %predicted_negatives = pred < threshold;
    predicted_positives = actual_positive;
    predicted_negatives = actual_negatives;
    
    tp = sum((predicted_positives + actual_positive) == 2);
    tn = sum((predicted_negatives + actual_negatives) == 2);
    
    fp = sum((predicted_positives + actual_negatives) == 2);
    fn = sum((predicted_negatives + actual_positive) ==2);
    
    cm = [tp fn; fp tn];
    
    tpr = tp/(tp + fn);
    fpr = fp/(fp + tn);

    tpr_array = [tpr_array tpr];
    fpr_array = [fpr_array fpr];
end

scatter(fpr_array, tpr_array)
xlim([-0.05, 1.05])
ylim([-0.05, 1.05])
grid on