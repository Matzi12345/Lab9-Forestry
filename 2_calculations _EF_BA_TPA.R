################################################################################
#                                                                              #
#                           2. Calculations – EF, BA and TPA                   #
#                                                                              #
################################################################################

# For this step, you are going to create new columns for the indices you will calculate.
# There are different options to add a new column to a dataframe:
# - Using the `$` Operator: This method directly assigns a value to a new column. For example, `dataframe$new_column <- value`.
# - Using `dplyr::mutate()`: This method allows chaining operations and is consistent with the `dplyr` workflow you've used in previous steps. 
#     For example, `dataframe <- dataframe %>% mutate(new_column = value)`.

# In this section, you will calculate several important indices used in forest inventory analysis:
# - Expansion Factor (EF): A factor used to scale up measurements from sample plots to per-acre values.
# - Trees Per Acre (TPA): The total number of trees in a sample plot, multiplied by the Expansion Factor (EF) to obtain the per-acre tree count.
# - Basal Area (BA): The area occupied by tree stems, calculated for each tree as \( BA = \pi r^2 \), where \( r \) is the radius of the tree's diameter.

# Note: In R, you can access the value of pi using the constant `pi`. You will use this in your calculations involving circular areas.
# Note: To raise a number to a power in R (e.g., squaring or cubing), you can use the `^` operator. For example, `x^2` calculates the square of x..

### Step 2.1: Calculate Expansion Factor (EF)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
plot_radius <- 58.5  
plot_area_acres <- (pi * plot_radius^2) / 43560
EF <- 1 / plot_area_acres
#----------------
#plot_radius <-    # in feet
#plot_area_acres <-  
#EF <-  
#----------------     


# Add EF as a new column
# You can use either the `$` operator or `dplyr::mutate()` to add EF.
trees$EF <- round(EF)
#----------------

#----------------

# Question: What is the value of EF? Round your answer to the nearest whole number.
round(EF)

### Step 2.2: Calculate Basal Area (BA) and Trees Per Acre (TPA)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Convert DBH from inches to diameter in feet: 
#   - DBH is currently in inches and represents the diameter at breast height.
#   - To use it in calculations requiring feet, convert it to feet: dia_ft = DBH in inches / 12.
#   - Add the result as a new column named `dia_ft` to the trees dataframe.

#----------------
trees <- trees %>% dplyr::mutate(dia_ft = DBH / 12)
#----------------

# Calculate BA per tree:  BA = π × (diameter in feet / 2)^2.
#   - Add the result as a new column named `BA` to the trees dataframe.
#----------------
trees <- trees %>% dplyr::mutate(BA = pi * (dia_ft / 2)^2)
#----------------

# Calculate BA per acre: BA_pa = BA × EF.
#   - Add the result as a new column named `BA_pa` to the trees dataframe.
#----------------
trees <- trees %>% dplyr::mutate(BA_pa = BA * EF)
#----------------

# Calculate TPA: TPA = 1 × EF.
#   - Add the result as a new column named `TPA` to the trees dataframe.
#----------------
trees <- trees %>% dplyr::mutate(TPA = 1 * EF)
#----------------


# Checkpoint: Review the Largest DBH Values
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Use the following code to verify your results:
#head(trees %>% arrange(desc(BA_pa)))
head(trees %>% dplyr::arrange(desc(BA_pa)))
# Your results should look similar to this:

#      Plot Code        Genus  Common.name  DBH Chojnacky_Code EF   dia_ft       BA    BA_pa TPA
#      P6  TUP Liriodendron Tulip poplar 40.1             27  4 3.341667 8.770334 35.08134   4
#      J6  CHO      Quercus Chestnut oak 38.2             23  4 3.183333 7.958920 31.83568   4
#      H5  TUP Liriodendron Tulip poplar 37.6             27  4 3.133333 7.710865 30.84346   4
#      K4  TUP Liriodendron Tulip poplar 36.9             27  4 3.075000 7.426431 29.70572   4
#      J6  CHO      Quercus Chestnut oak 35.7             23  4 2.975000 6.951265 27.80506   4
#      H2  TUP Liriodendron Tulip poplar 35.4             27  4 2.950000 6.834928 27.33971   4
