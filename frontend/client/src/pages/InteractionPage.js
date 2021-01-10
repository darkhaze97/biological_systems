import React from "react";
import axios from "axios";
import { Button, TextField } from "@material-ui/core"

const InteractionPage = ({...props}) => {

    const [values, setValues] = React.useState({
        molecule1: '',
        type1: '',
        molecule2: '',
        type2: '',
    })

    const handleChange = name => event => {
        setValues({ ...values, [name]: event.target.value });
    }

    const handleSubmit = (event) => {
        event.preventDefault()

        axios.post("http://127.0.0.1:8080/interactions", {...values})
            .then((response) => {
                console.log(response)
                props.history.push('/interactions/results', {response: response.data})
            })
            .catch((err) => {})
    }

    return (
        <div>
            <header>
                <h3>
                    Interactions between molecules
                </h3>
            </header>
            <form onSubmit={handleSubmit}>
                <TextField 
                    label="Molecule 1"
                    variant="outlined"
                    type="text" 
                    id="molecule1" 
                    name="molecule1" 
                    value={values.molecule1} 
                    onChange={handleChange("molecule1")}
                /><br></br>
                <TextField
                    label="Type of Molecule 1"
                    variant="outlined"
                    type="text" 
                    id="type1" 
                    name="type1" 
                    value={values.type1} 
                    onChange={handleChange("type1")} 
                /><br></br>
                <TextField
                    label="Molecule 2"
                    variant="outlined"
                    type="text"
                    id="molecule2"
                    name="molecule2"
                    value={values.molecule2}
                    onChange={handleChange("molecule2")}
                /><br></br>
                <TextField
                    label="Type of Molecule 2"
                    variant="outlined"
                    type="text"
                    id="type2"
                    name="type2"
                    value={values.type2}
                    onChange={handleChange("type2")}
                /><br></br>
                <Button type="submit" variant="contained" color="primary">
                    Submit
                </Button>
            </form>
        </div> 
    )

};

export default InteractionPage;