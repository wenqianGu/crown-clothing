/**
 * SASS dynamic class name  > string interpreted
 * if otherProps 存在，classname =  shrink  form-input-label
 * 如果不存在，classname = form-input-label；
 *
 * className={`${otherProps.value.length ? 'shrink' : ''
 *                         } form-input-label`}
 *
 * if label exists, then display the following code
 *    label && xxx
 * */
import './form-input.styles.scss'

const FormInput = ({label, ...otherProps}) => {
    return (
        <div className="group">
            <input className='form-input' {...otherProps}/>
            {label && (
                <label
                    className={`${otherProps.value.length ? 'shrink' : ''
                    } form-input-label`}
                >
                    {label}
                </label>
            )
            }
        </div>
    )
}
export default FormInput;