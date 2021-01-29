import React from "react";
import axios from "axios";
import { Button, TextField } from "@material-ui/core"

const ConceptPage = (props) => {

    const [values, setValues] = React.useState({
        name: '',
    })

    const handleChange = name => event => {
        setValues({ ...values, [name]: event.target.value });
    }

    const handleSubmit = (event) => {
        event.preventDefault()

        axios.post("http://127.0.0.1:8080/concepts/results/all", {...values})
            .then((response) => {
                console.log(response)
                props.history.push('/concepts/results/all', {response: response.data})
            })
            .catch((err) => {})
    }

    return (
        <div class="App">
            <header>
                <h3>
                   Biological Concepts 
                </h3>
            </header>
            <form onSubmit={handleSubmit}>
                <TextField
                    label="Concept Name"
                    variant="outlined"
                    type="text" 
                    id="name" 
                    name="name" 
                    value={values.molecule1} 
                    onChange={handleChange("molecule1")}
                /><br/>
                <Button type="submit" variant="contained" color="primary">
                    Submit
                </Button>
            </form>
        </div>
    )
}

export default ConceptPage;