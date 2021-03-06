library(shiny)

renderInputs <- function() {
  wellPanel(
    fluidRow(
      column(3,
             selectInput(inputId='tissue', label ='Tissue', choices =c("urine","serum"))),
      column(3,
             selectInput(inputId='metabolite', label ='Metabolite', choices = NULL)),
      column(3,
             selectInput(inputId='disease', label = 'Disease', choices =c("Coronary Heart Disease"))),
      column(3,
             numericInput('pvalue', 'P-value', 0.05,min = 0, max = 1))
    ),
    fluidRow(
      column(3,actionButton("runif", "Run")),
      column(3,actionButton("reset","Clear"))
    )
    
  )
}

# Define UI for application 
fluidPage(
  theme="simplex.min.css",
  tags$style(type="text/css","label {font-size: 12px;}",".recalculating {opacity: 1.0;}"),
  # Application title
  tags$h2("MR BACOn: Mendelian Randomization analysis of Biomarker Associations for Causality with Outcomes"),
  p("Find causal associations between your metabolite of interest and disease."),
  hr(),
          
  # This is all the input 
    fluidRow(
      column(6, tags$h3("Inputs"))
    ),
    fluidRow(
    renderInputs()
    ),
    
    conditionalPanel(
      condition = "input.runif && !input.reset && output.renderUIForNoAssoc != 'noassoc' 
      && output.renderUIForOutput != 'show'",
      fluidRow(
        column(6, tags$h3("Running Two-Sample MR ...."))
      )
    ),   
  
  conditionalPanel(
    condition = "output.renderUIForNoAssoc=='noassoc'",
    fluidRow(
      column(6, tags$h3("No Association Found"))
    )
  ),   
    # This is all the outputs 
    conditionalPanel(
      condition = "output.renderUIForOutput == 'show'",
      fluidRow(
      column(6,tags$h3(textOutput("outputTitle")))
      ),
          fluidRow(
            column(6,tags$h3("MR Tests")),
            column(6,tags$h3("Funnel Plot"))
          ),
          fluidRow(
            # Button
            column(6,downloadButton("downloadMRTests", "Download Plot")),
            column(6,downloadButton("downloadFunnelPlot", "Download Plot"))
          ),
          fluidRow(
            column(6,
                   plotOutput("MRtests", height = "600px")
                   
            ),
            column(6,
                   plotOutput("funnelPlot", height = "600px")
            )
          ),
          fluidRow(
            column(6,tags$h3("Forest Plot")),
            column(6,tags$h3("Pathway Plot"))
          ),
          fluidRow(
            # Button
            column(6,downloadButton("downloadForestPlot", "Download Plot")),
            column(6,downloadButton("downloadPathwayPlot", "Download Plot"))
          ),
          fluidRow(
            column(6,
                   plotOutput("forestPlot", height = "600px")
            ),
            column(6,
                   plotOutput("pathwayPlot", height= "600px"))
          ),
          fluidRow(
            # Button
            downloadButton("downloadData", "Download Data")
          )
      )
)