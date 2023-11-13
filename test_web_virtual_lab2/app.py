from flask import Flask, render_template
from plotly.offline import plot
import plotly.graph_objects as go
import ipywidgets as widgets
from IPython.display import display
from wtforms import FloatField, SubmitField
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField, FileField, TextAreaField
from wtforms.validators import DataRequired, Length, Email, EqualTo, ValidationError

app = Flask(__name__)
app.config['SECRET_KEY'] ='secret!'

class SliderForm(FlaskForm):
    slider = FloatField('Slider')

@app.route('/')
def index():
    form = SliderForm()
    # Créez un diagramme ternaire vide
    fig = go.Figure()

    # Créez un point initial
    initial_point = {'A': 0.2, 'B': 0.2, 'C': 0.6}
    trace = go.Scatterternary(
        a=[initial_point['A']],
        b=[initial_point['B']],
        c=[initial_point['C']],
        mode='markers',
        marker=dict(size=10, color='blue'),
        hoverinfo=['a', 'b', 'c'],
        name='Point'
    )

    fig.add_trace(trace)

     # Create a FloatSlider
    a_slider = widgets.FloatSlider(
        value=initial_point['A'],
        min=0.0,
        max=1.0,
        step=0.01,
        description='A:'
    )

    # Create a function to update the point based on the slider value
    def update_point(a):
        trace.x = [a]
        fig.update_traces(patch={'x': [[a]]})

# Affichez le diagramme ternaire
    fig.show()
        # Create a Markup object with the Plotly content
    plot_div = plot(fig, output_type='div', include_plotlyjs='cdn')

    return render_template('index.html', plot_div=plot_div, a_slider=a_slider, form=form)


if __name__ == '__main__':
    app.run(debug=True)
