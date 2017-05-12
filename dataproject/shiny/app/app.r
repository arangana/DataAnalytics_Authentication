#Import Libraries
library(shiny)
library("googlesheets")

#Catch the Google Doc to store Data
gs <- gs_url("https://docs.google.com/spreadsheets/d/1avezQT-LYwiHfbN65AuTWqndaJOVStYToE10AHD9cx4/edit#gid=922404752", lookup = NULL, visibility = NULL, verbose = FALSE)
gs2 <- gs_url("https://docs.google.com/spreadsheets/d/12LGjNh7ev1_bHtdm2wZmmFUdpFeBUjeqYRhdWeKFO0I/edit#gid=0", lookup = NULL, visibility = NULL, verbose = FALSE)

#Import Dataset and model
#load("~/Documents/CMU_Acads/Data Analytics/Project/update/app/Untitled.RData")
dataset <- data5
model <- lm(SalePrice~., data = data5)

#UI

ui <- fluidPage(theme = "bootstrap1.css", ##Link Bootstrap Theme
                tags$head(tags$script(src = "message-handler.js")), ##Import Message Handling
                
                #Begin Questionnaire
                titlePanel("Welcome!!"),
                actionButton(inputId='back', label="Go Back",onclick ="location.href='http://google.com';"),
                h1("Interested in selling a house? Just fill up this form and let our 
                   algorithm choose the best price for you", 
                   style = "font-family: 'Source Sans Pro';
                   color: #fff; text-align: center;
                   background: url(house.png) no-repeat center center fixed; 
                   -webkit-background-size: cover;
                   -moz-background-size: cover;
                   -o-background-size: cover;
                   background-size: cover;
background-attachment: fixed;
                  height: 200px;
                   padding: 200px"),
                
                br(),
               
                h3("Contact Information"),
                br(),
                
                div(style="display:inline-block",textInput(inputId = "Name", 
                          label = "Please Enter your Full Name")),
                
                div(style="display:inline-block",textInput(inputId = "Email", 
                          label = "Please Enter your email address")),
                
                div(style="display:inline-block",textInput(inputId = "Phone", 
                          label = "Please Enter your phone Number")),
                
                br(),
                h3("General Information"),
                h6("Please fill all the boxes to provide a better price estimate"),
                br(),
                div(style="display:inline-block",numericInput(inputId = "Lot.Area", 
                             label = "Please Enter the Lot Area (sq.ft)", 
                             value = 1000, 
                             min = 0)), 
                
                div(style="display:inline-block",selectInput(inputId = "Street", 
                            label = "Enter the Paving of the Street", 
                            choices = list("Gravel" = "Grvl", 
                                           "Paved" = "Pave"), 
                            selected = "Gravel")),
                
                div(style="display:inline-block",selectInput(inputId = "Lot.Shape", 
                            label = "Enter the Shape of the plot", 
                            choices = list("Regular" = "Reg", 
                                           "Slightly Irregular" = "IR1", 
                                           "Moderately Irregular" = "IR2", 
                                           "Irregular" = "IR3"), 
                            selected = "Regular")),
                br(),
                div(style="display:inline-block",selectInput(inputId = "Land.Contour", 
                            label = "Enter the flatness of the property",
                            choices = list("Near Flat/Level" = "Lvl", 
                                           "Banked" = "Bnk", 
                                           "Hillside" = "HLS", 
                                           "Depression" = "Low"), 
                            selected = "Near Flat/Level")),
                
                div(style="display:inline-block",selectInput(inputId = "Lot.Config", 
                            label = "Enter the Lot Configuration",
                            choices = list("Inside Lot" = "Inside", 
                                           "Corner Lot" = "Corner", 
                                           "Cul-De-Sac" = "CulDSac", 
                                           "Frontage on 2 sides" = "FR2", 
                                           "Frontage on 3 sides" = "FR3"), 
                            selected = "Inside")),
                
                div(style="display:inline-block",selectInput(inputId = "Land.Slope", 
                            label = "Enter the Slope of the land",
                            choices = list("Gentle Slope" = "Gtl", 
                                           "Moderate Slope" = "Mod", 
                                           "Severe Slope" = "Sev"), 
                            selected = "Gentle Slope")),
                br(),
                div(style="display:inline-block",selectInput(inputId = "Neighborhood", 
                            label = "Enter the Neighborhood you live in",
                            choices = levels(data5$Neighborhood), 
                            selected = "OldTown")),
                
                div(style="display:inline-block",selectInput(inputId = "Condition.1", 
                            label = "Proximity - Select one of the options",
                            choices = list("Adjacent to arterial street" =  "Artery",
                                          "Adjacent to feeder street" =	"Feedr",
                                          "Normal" = "Norm"	,
                                          "Within 200' of North-South Railroad" = "RRNn",
                                          "Adjacent to North-South Railroad" = "RRAn",
                                          "Near positive off-site feature--park, greenbelt, etc." = "PosN",
                                          "Adjacent to postive off-site feature" = "PosA",
                                          "Within 200' of East-West Railroad" = "RRNe",
                                          "Adjacent to East-West Railroad" = "RRAe"), 
                          selected = "Normal")),
                
                div(style="display:inline-block",selectInput(inputId = "Condition.2", 
                            label = "If you wish to select more than one condition, else enter Normal",
                            choices = list("Adjacent to arterial street" =  "Artery",
                                            "Adjacent to feeder street" =	"Feedr",
                                            "Normal" = "Norm"	,
                                            "Within 200' of North-South Railroad" = "RRNn",
                                            "Near positive off-site feature--park, greenbelt, etc." = "PosN",
                                            "Adjacent to postive off-site feature" = "PosA"), 
                            selected = "Normal")),
                br(),
                div(style="display:inline-block",selectInput(inputId = "Bldg.Type", 
                            label = "Enter the type of building",
                            choices = list("Single Family Detached" = "1Fam",
                                          "Two-family Conversion; originally built as one-family dwelling" =	"2fmCon",
                                          "Duplex" = "Duplex"	,
                                          "Townhouse End Unit" = "TwnhsE",
                                          "Townhouse Inside Unit" = "Twnhs"), 
                            selected = "Single Family Detached")),
                div(style="display:inline-block",selectInput(inputId = "Exter.Qual", 
                            label = "Select the External Quality",
                            choices = list("Excellent" = "Ex",
                                           "Good" = "Gd",
                                           "Average" = "TA",
                                           "Fair" = "Fa",
                                           "Poor" = "Po"), 
                            selected = "Average")),
                br(),
                
                h3("House Details"),
                
                div(style="display:inline-block",selectInput(inputId = "House.Style", 
                            label = "Enter the Housing style",
                            choices = list("One story"	=  "1Story",
                                          "One and one-half story: 2nd level finished"	     =  "1.5Fin",
                                          "One and one-half story: 2nd level unfinished"	   =    "1.5Unf",
                                          "Two story"	 =      "2Story",
                                          "Two and one-half story: 2nd level finished"	     =  "2.5Fin",
                                          "Two and one-half story: 2nd level unfinished"	  =     "2.5Unf",
                                          "Split Foyer"	  =     "SFoyer",
                                          "Split Level"	 =      "SLvl"), 
                            selected = "1Story")),
                
                div(style="display:inline-block",numericInput(inputId = "Overall.Qual", 
                             label = "Enter the Overall Quality of the house (1 - 10)",
                             min = 1,
                             max = 10, 
                             step = 1, 
                             value = 5)),
                
                div(style="display:inline-block",numericInput(inputId = "Overall.Cond", 
                             label = "Enter the Overall Condition of the house (1 - 10)", 
                             min = 1, 
                             max = 10, 
                             step = 1, 
                             value = 5)),
                br(),
                
                div(style="display:inline-block",numericInput(inputId = "Year.Built", 
                             label = "Enter the Year the house was built in", 
                             value = 1970,
                             min = 0)),
                
                div(style="display:inline-block",numericInput(inputId = "Year.Remod.Add", 
                             label = "Enter the Year the house was modelled (Same as year built if no remodelling done)", 
                             value = 1970)),
                
                div(style="display:inline-block",selectInput(inputId = "Roof.Matl", 
                            label = "Enter the Roofing Material Used",
                            choices = list("Clay or Tile"=	"ClyTile",
                                            "Standard (Composite) Shingle"	 =      "CompShg",
                                            "Membrane"	=       "Membran",
                                            "Metal"	=       "Metal",
                                            "Roll"	 =      "Roll",
                                            "Gravel & Tar"	=       "Tar&Grv",
                                            "Wood Shakes"	  =     "WdShake",
                                            "Wood Shingles"	=       "WdShngl"), 
                            selected = "Clay or Tile")),
                
                br(),
                div(style="display:inline-block",selectInput(inputId = "Exterior.1st", 
                            label = "Select the Exterior Covering of the house",
                            choices = list("Asbestos Shingles"=	"AsbShng",
                                          "Asphalt Shingles"	=       "AsphShn",
                                          "Brick Common"	=       "BrkComm",
                                          "Brick Face"	   =    "BrkFace",
                                          "Cinder Block"	 =      "CBlock",
                                          "Cement Board"	 =      "CemntBd",
                                          "Hard Board"	   =    "HdBoard",
                                          "Imitation Stucco"	 =      "ImStucc",
                                          "Metal Siding"	=       "MetalSd",
                                          "Other"	  =     "Other",
                                          "Plywood"	  =     "Plywood",
                                          "PreCast"	=       "PreCast",
                                          "Stone"	  =     "Stone",
                                          "Stucco"	 =      "Stucco",
                                          "Vinyl Siding"	 =      "VinylSd",
                                          "Wood Siding"	  =     "Wd Sdng",
                                          "Wood Shingles"	 =      "WdShing"), 
                            selected = "Asbestos Shingles")),
                
                div(style="display:inline-block",selectInput(inputId = "Mas.Vnr.Type", 
                            label = "Select the Masonary Veneer Type",
                            choices = list("Brick Common"=	"BrkCmn",
                                          "Brick Face"	 =      "BrkFace",
                                          "Cinder Block"	=       "CBlock",
                                          "None"  =     "None",
                                          "Stone"	 =      "Stone"), 
                            selected = "None")),
                
                div(style="display:inline-block",numericInput(inputId = "Mas.Vnr.Area", 
                             label = "Enter the Masonary Veneer Area (sq. ft)",
                             value = 0, 
                             min = 0)),
                
                br(),
                h3("House Details Interior"),
                br(),
                
                div(style="display:inline-block",numericInput(inputId = "Total.Bsmt.SF", 
                             label = "Enter the total Basement Area (sq. ft)", 
                             value = 0, 
                             min = 0)),
                
                div(style="display:inline-block",numericInput(inputId = "X1st.Flr.SF", 
                             label = "Enter the First Floor Area (sq. ft)", 
                             value = 0, 
                             min = 0)),
                
                div(style="display:inline-block",numericInput(inputId = "Gr.Liv.Area", 
                             label = "Enter the Living Room Area (sq. ft)", 
                             value = 0, 
                             min = 0)),
                br(),
                
                div(style="display:inline-block",numericInput(inputId = "TotRms.AbvGrd", 
                             label = "Enter the total number of rooms", 
                             value = 0, 
                             min = 0)),
                
                div(style="display:inline-block",selectInput(inputId = "Kitchen.Qual", 
                            label = "Select the Kitchen Quality",
                            choices = list("Excellent" = "Ex",
                                            "Good" = "Gd",
                                            "Average" = "TA",
                                            "Fair" = "Fa",
                                            "Poor" = "Po"), 
                            selected = "Average")),
                
                div(style="display:inline-block",numericInput(inputId = "Fireplaces", 
                             label = "Enter the Number of Fireplaces", 
                             min = 0, 
                             max = 5, 
                             value = 0, 
                             step = 1)),
                
                br(),
                
                div(style="display:inline-block",selectInput(inputId = "Garage.Finish", 
                            label = "Select the Finish of the Garage",
                            choices = list("No Garage" = "",
                                          "Finished" = "Fin",
                                          "Rough Finished" = "RFn",
                                          "Unfinished" = "Unf"), 
                            selected = "Fin")),
                
                div(style="display:inline-block",numericInput(inputId = "Garage.Cars", 
                             label = "Enter the capacity of Garage in number of Cars",  
                             min = 0,
                             max = 5, 
                             step = 1, 
                             value = 0)),
                
                div(style="display:inline-block",numericInput(inputId = "Garage.Area", 
                             label = "Enter the Garage Area", 
                             value = 0, 
                             min = 0)),
                
                br(),
                
                div(style="display:inline-block",selectInput(inputId = "Garage.Qual", 
                            label = "Select the Garage Quality",
                            choices = list("No Garage" = "",
                                            "Excellent" = "Ex",
                                            "Good" = "Gd",
                                            "Average" = "TA",
                                            "Fair" = "Fa",
                                            "Poor" = "Po"), 
                            selected = "Average")),
                
                div(style="display:inline-block",selectInput(inputId = "Garage.Cond", 
                            label = "Select the Garage Condition",
                            choices = list("No Garage" = "",
                                            "Excellent" = "Ex",
                                            "Good" = "Gd",
                                            "Average" = "TA",
                                            "Fair" = "Fa",
                                            "Poor" = "Po"), 
                            selected = "Average")),
                
                div(style="display:inline-block",numericInput(inputId = "Pool.Area", 
                             label = "Enter the Swimming Pool Area (0 for no pool)", 
                             value = 0,
                             min = 0)),
                
                br(),
                h4("What would you prefer?"),
  
                selectInput(inputId = "Sale.Type", 
                            label = "Select the Sale Type",
                            choices = list("Warranty Deed - Conventional"=	"WD" ,
                                          "Warranty Deed - Cash"	 =      "CWD",
                                          "Warranty Deed - VA Loan"	  =     "VWD",
                                          "Home just constructed and sold"	=       "New",
                                          "Court Officer Deed/Estate"	  =     "COD",
                                          "Contract 15% Down payment regular terms"	  =     "Con",
                                          "Contract Low Down payment and low interest"	=       "ConLw",
                                          "Contract Low Interest"	  =     "ConLI",
                                          "Contract Low Down"	=       "ConLD",
                                          "Other"	  =     "Oth"), 
                            selected = "Warranty Deed - Cash"),
                p("Click the button to learn about the best possible price to offer for your house"),
                ## Prediction Button
                actionButton("predict", "Best Price!!"),
                
                br(),
                br(),
                
                numericInput(inputId = "SalePrice", 
                             label = "Enter the Sale Price of the House ($$)", 
                             value = 0),
                
                ## Submit Button
                actionButton("submit", "Submit"),
                
                actionButton(inputId='back2', label="Go Back", onclick ="location.href='http://google.com';"),
                br(),
                br(),
                
                ## Contact Box 
               h3("Contact Us"),
               h5("Aditya Ranganath : aditya.ranganath@west.cmu.edu"),
               h5("Manini Chattopadhyay : manini.chattopadhyay@west.cmu.edu"),
               h5("Nagarjun Srinivasan : nagarjun.srinivasan@west.cmu.edu")
                
                
                
                
                ##OUTPUTS
                #verbatimTextOutput(outputId = "House"),
                #verbatimTextOutput(outputId = "Data"),
                #verbatimTextOutput(outputId = "Prediction")
)
#server page
server <- function(input, output, session) {
                                    ##Reactive dataframe of features for prediction
                                    house <- reactive({
                                      data.frame(
                                        "Lot.Area" = input$Lot.Area,
                                        "Street" = factor(input$Street),
                                        "Lot.Shape" = factor(input$Lot.Shape),
                                        "Land.Contour" = factor(input$Land.Contour),
                                        "Lot.Config" = factor(input$Lot.Config),
                                        "Land.Slope" = factor(input$Land.Slope),
                                        "Neighborhood" = factor(input$Neighborhood),
                                        "Condition.1" = factor(input$Condition.1),
                                        "Condition.2" = factor(input$Condition.2),
                                        "Bldg.Type" = factor(input$Bldg.Type),
                                        "House.Style" = factor(input$House.Style),
                                        "Overall.Qual" = input$Overall.Qual,
                                        "Overall.Cond" = input$Overall.Cond,
                                        "Year.Built" = input$Year.Built,
                                        "Year.Remod.Add" = input$Year.Remod.Add,
                                        "Roof.Matl" = factor(input$Roof.Matl),
                                        "Exterior.1st" = factor(input$Exterior.1st),
                                        "Mas.Vnr.Type" = factor(input$Mas.Vnr.Type),
                                        "Mas.Vnr.Area" = input$Mas.Vnr.Area,
                                        "Exter.Qual" = factor(input$Exter.Qual),
                                        "Total.Bsmt.SF" = input$Total.Bsmt.SF,
                                        "X1st.Flr.SF" = input$X1st.Flr.SF,
                                        "Gr.Liv.Area" = input$Gr.Liv.Area,
                                        "TotRms.AbvGrd" = input$TotRms.AbvGrd,
                                        "Kitchen.Qual" = factor(input$Kitchen.Qual),
                                        "Fireplaces" = input$Fireplaces,
                                        "Garage.Finish" = factor(input$Garage.Finish),
                                        "Garage.Cars" = input$Garage.Cars,
                                        "Garage.Area" =  input$Garage.Area,
                                        "Garage.Qual" = factor(input$Garage.Qual),
                                        "Garage.Cond" = factor(input$Garage.Cond),
                                        "Pool.Area" = input$Pool.Area,
                                        "Sale.Type" = factor(input$Sale.Type)
                                      )
                                    })
                                    
                                    ##Reactive data frame of all information to be pushed on the sheet
                                    data <- reactive({
                                      data.frame(
                                        "Name" = input$Name,
                                        "Email" = input$Email,
                                        "Phone" = input$Phone,
                                        "Lot.Area" = input$Lot.Area,
                                        "Street" = input$Street,
                                        "Lot.Shape" = input$Lot.Shape,
                                        "Land.Contour" = input$Land.Contour,
                                        "Lot.Config" = input$Lot.Config,
                                        "Land.Slope" = input$Land.Slope,
                                        "Neighborhood" = input$Neighborhood,
                                        "Condition.1" = input$Condition.1,
                                        "Condition.2" = input$Condition.2,
                                        "Bldg.Type" = input$Bldg.Type,
                                        "House.Style" = input$House.Style,
                                        "Overall.Qual" = input$Overall.Qual,
                                        "Overall.Cond" = input$Overall.Cond,
                                        "Year.Built" = input$Year.Built,
                                        "Year.Remod.Add" = input$Year.Remod.Add,
                                        "Roof.Matl" = input$Roof.Matl,
                                        "Exterior.1st" = input$Exterior.1st,
                                        "Mas.Vnr.Type" = input$Mas.Vnr.Type,
                                        "Mas.Vnr.Area" = input$Mas.Vnr.Area,
                                        "Exter.Qual" = input$Exter.Qual,
                                        "Total.Bsmt.SF" = input$Total.Bsmt.SF,
                                        "X1st.Flr.SF" = input$X1st.Flr.SF,
                                        "Gr.Liv.Area" = input$Gr.Liv.Area,
                                        "TotRms.AbvGrd" = input$TotRms.AbvGrd,
                                        "Kitchen.Qual" = input$Kitchen.Qual,
                                        "Fireplaces" = input$Fireplaces,
                                        "Garage.Finish" = input$Garage.Finish,
                                        "Garage.Cars" = input$Garage.Cars,
                                        "Garage.Area" =  input$Garage.Area,
                                        "Garage.Qual" = input$Garage.Qual,
                                        "Garage.Cond" = input$Garage.Cond,
                                        "Pool.Area" = input$Pool.Area,
                                        "Sale.Type" = input$Sale.Type,
                                        "SalePrice" = input$SalePrice
                                      )
                                    })
                                    
                                    ##Reactive dataframe on clicking PREDICT - predicted price with 90% CI
                                    prediction <- eventReactive(input$predict, {
                                      predict(model, newdata = house(), interval = "confidence", level = 0.9)
                                    })
                                   
                                    ##Data frame for Dataset Generation
                                    dset <- eventReactive(input$predict, {
                                      data.frame(
                                        "Lot.Area" = input$Lot.Area,
                                        "Street" = factor(input$Street),
                                        "Lot.Shape" = factor(input$Lot.Shape),
                                        "Land.Contour" = factor(input$Land.Contour),
                                        "Lot.Config" = factor(input$Lot.Config),
                                        "Land.Slope" = factor(input$Land.Slope),
                                        "Neighborhood" = factor(input$Neighborhood),
                                        "Condition.1" = factor(input$Condition.1),
                                        "Condition.2" = factor(input$Condition.2),
                                        "Bldg.Type" = factor(input$Bldg.Type),
                                        "House.Style" = factor(input$House.Style),
                                        "Overall.Qual" = input$Overall.Qual,
                                        "Overall.Cond" = input$Overall.Cond,
                                        "Year.Built" = input$Year.Built,
                                        "Year.Remod.Add" = input$Year.Remod.Add,
                                        "Roof.Matl" = factor(input$Roof.Matl),
                                        "Exterior.1st" = factor(input$Exterior.1st),
                                        "Mas.Vnr.Type" = factor(input$Mas.Vnr.Type),
                                        "Mas.Vnr.Area" = input$Mas.Vnr.Area,
                                        "Exter.Qual" = factor(input$Exter.Qual),
                                        "Total.Bsmt.SF" = input$Total.Bsmt.SF,
                                        "X1st.Flr.SF" = input$X1st.Flr.SF,
                                        "Gr.Liv.Area" = input$Gr.Liv.Area,
                                        "TotRms.AbvGrd" = input$TotRms.AbvGrd,
                                        "Kitchen.Qual" = factor(input$Kitchen.Qual),
                                        "Fireplaces" = input$Fireplaces,
                                        "Garage.Finish" = factor(input$Garage.Finish),
                                        "Garage.Cars" = input$Garage.Cars,
                                        "Garage.Area" =  input$Garage.Area,
                                        "Garage.Qual" = factor(input$Garage.Qual),
                                        "Garage.Cond" = factor(input$Garage.Cond),
                                        "Pool.Area" = input$Pool.Area,
                                        "Sale.Type" = factor(input$Sale.Type),
                                        "PP" = prediction()[1],
                                        "PP90L" = prediction()[2],
                                        "PP90U" = prediction()[3]
                                      )
                                    })
                                    
                                    ##Print house data
                                    #output$House <- renderPrint(
                                    #  {
                                    #    house()
                                    #  }
                                    #)
                                    
                                    ##Print all data
                                    #output$Data <- renderPrint(
                                    #  {
                                    #    data()
                                    #  }
                                    #)
                                    
                                    ##Print Prediction
                                    #output$Prediction <- renderPrint(
                                    #  {
                                    #    prediction()
                                    #  }
                                    #)
                                    
                                    ##On submit, push to sheet and send message
                                    observeEvent(input$submit, {
                                      gs_add_row(gs, ws = 1, input = data(), verbose = FALSE)
                                      gs_add_row(gs2, ws = 1, input = dset(), verbose = FALSE)
                                      session$sendCustomMessage(type = 'testmessage',
                                                                message = 'Successfully Submitted')
                                    })
                                    
                                    observeEvent(input$predict, {
                                      session$sendCustomMessage(type = 'testmessage',
                                                                message = c('From the data you have entered, We predict the best price of your propertry to be', ceiling(prediction()[1]), 'dollars'))
                                    })
}

shinyApp(ui = ui, server = server)