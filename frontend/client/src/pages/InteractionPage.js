import React from "react";
import axios from "axios";
import { Button, TextField, Select, FormControl, MenuItem, Menu, InputLabel } from "@material-ui/core"

const InteractionPage = (props) => {

    var entityTypesArray = JSON.parse(localStorage.getItem("entityTypes"));
    console.log(entityTypesArray)

    const [values, setValues] = React.useState({
        entity1: '',
        type1: '',
        entity2: '',
        type2: '',
    })

    const [types, setTypes] = React.useState({
        type1: 'Any',
        type2: '',
    });

    const handleChange = name => event => {
        setValues({ ...values, [name]: event.target.value });
    }

    const handleTypeChange = event => {
        const name = event.target.name
        console.log("Hi")
        console.log(name)
        setTypes({ ...types, [name]: event.target.value})
        console.log(types.type1)
    }

    const createDropdowns = () => {
        return (         
            entityTypesArray.map( function (item, index) {
                console.log(item)
                return (
                    <MenuItem value={item}>
                        {item}
                    </MenuItem>
                )
            })
        )
    }

    const handleSubmit = (event) => {
        event.preventDefault()

        axios.post("http://127.0.0.1:8080/interactions/results/all", {...values})
            .then((response) => {
                console.log(response)
                props.history.push('/interactions/results/all', {response: response.data})
            })
            .catch((err) => {})
    }

    console.log("I have reached here.")

    return (
        <div class="App">
            <header>
                <h3>
                    Interactions between entities
                </h3>
            </header>
            <form onSubmit={handleSubmit}>
                <TextField 
                    label="Entity 1"
                    variant="outlined"
                    type="text" 
                    id="entity1" 
                    name="entity1" 
                    value={values.molecule1} 
                    onChange={handleChange("entity1")}
                /><br></br> 
                <div id="entity1type">
                    <Button variant="contained" color="primary">
                        Entity Type 1
                    </Button>
                </div>        
                <FormControl style={{minWidth: 120}}>
                    <InputLabel id="type1">Entity Type</InputLabel>
                    <Select
                     labelId="type1"
                     id="type1"
                     value={types.type1}
                     onChange={handleTypeChange}
                     inputProps={{name: 'type1'}}
                     >
                        <MenuItem value={"Any"}>
                            Any
                        </MenuItem>
                        {createDropdowns()}
                    </Select>   
                </FormControl> 


                <TextField
                    label="Type of Entity 1"
                    variant="outlined"
                    type="text" 
                    id="type1" 
                    name="type1" 
                    value={values.type1} 
                    onChange={handleChange("type1")} 
                /><br></br>
                <TextField
                    label="Entity 2"
                    variant="outlined"
                    type="text"
                    id="entity2"
                    name="entity2"
                    value={values.molecule2}
                    onChange={handleChange("entity2")}
                /><br></br>
                <TextField
                    label="Type of Entity 2"
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